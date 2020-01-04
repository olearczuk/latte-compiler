module Backend.Statement where

import Grammar.AbsLatte
import Grammar.PrintLatte
import Backend.Expression
import Backend.Utils
import Control.Monad.Reader

genStmts :: [Statement] -> Backend ()
genStmts [] = return ()
genStmts (stmtH:stmtT) = do
  f <- genStmt stmtH
  local f $ genStmts stmtT

genStmt :: Statement -> Backend (Env -> Env)
genStmt stmt = case stmt of
  Empty _ -> return id

  BStmt _ (Block _ stmts) -> local nextPrefix $ genStmts stmts >> return id

  Decl _ _ [] -> do
    actEnv <- ask
    return $ \env -> actEnv
  Decl pos varType (itemsH:itemsT) -> do
    f <- genSingleVarDecl itemsH varType
    local f $ (genStmt $ Decl pos varType itemsT)

  Ass _ x expr -> do
    genExpr expr
    loc <- getVarLoc x
    addLine $ "movl %eax, " ++ loc
    return id

  Incr _ x -> do
    loc <- getVarLoc x
    addLine $ "addl $1, " ++ loc
    return id

  Decr _ x -> do
    loc <- getVarLoc x
    addLine $ "subl $1, " ++ loc
    return id

  Ret _ expr -> genExpr expr >> addLines ["leave", "ret"] >> return id

  VRet _ -> addLines ["leave", "ret"] >> return id

  Cond _ expr innerStmt -> do
    genExpr expr
    curBlock <- curBlockCounter
    let curIf = "_if_" ++ curBlock ++ "_end"
    addLines ["cmp $0, %eax", "je " ++ curIf]
    local nextPrefix $ genStmt innerStmt
    addLine $ curIf ++ ":"
    return id

  CondElse _ expr stmt1 stmt2 -> do
    genExpr expr
    curBlock <- curBlockCounter
    let curIf = "_if_" ++ curBlock
    addLines ["cmp $0, %eax", "je " ++ curIf ++ "_else"]
    local nextPrefix $ genStmt stmt1
    addLines ["jmp " ++ curIf ++ "_end", curIf ++ "_else:"]
    local nextPrefix $ genStmt stmt2
    addLine $ curIf ++ "_end:"
    return id

  While _ expr innerStmt  -> do
    curBlock <- curBlockCounter
    let curWhile = "_while_" ++ curBlock
    addLine $ curWhile ++ ":"
    local nextPrefix $ do
      genExpr expr
      addLines ["cmp $0, %eax", "je " ++ curWhile ++ "_end"]
      genStmt innerStmt
      addLine $ "jmp " ++ curWhile
    addLine $ curWhile ++ "_end:"
    return id


  SExp _ expr -> genExpr expr >> return id

  where
    genSingleVarDecl :: IItem -> TType -> Backend (Env -> Env)
    genSingleVarDecl item varType = do
      loc <- getCurLoc
      case item of
        NoInit _ x -> do
          case varType of
            Str _ -> addLines ["call emptyString", "movl %eax, " ++ (show loc) ++ "(%ebp)"]
            _ -> addLine ("movl $0, " ++ (show loc) ++ "(%ebp)")
          saveVarOnStack x varType
        Init _ x expr -> do
          genExpr expr
          case varType of
            _ -> addLine ("movl %eax, " ++ (show loc) ++ "(%ebp)")
          saveVarOnStack x varType

