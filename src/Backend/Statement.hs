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

  Ass _ (Var _ x) expr -> do
    loc <- getVarLoc x
    genExpr expr
    addLine $ "movl %eax, " ++ loc
    return id

  Ass _ (ObjField _ lval x) expr -> do
    genExpr expr
    pushEax
    (Class _ classId) <- genExpr $ ELValue Nothing lval
    popEcx
    (varPos, _) <- getFieldLoc classId x
    addLine $ "movl %ecx, " ++ (show varPos) ++ "(%eax)"
    return id

  Incr _ (Var _ x) -> do
    loc <- getVarLoc x
    addLine $ "addl $1, " ++ loc
    return id

  Decr _ (Var _ x) -> do
    loc <- getVarLoc x
    addLine $ "subl $1, " ++ loc
    return id

  Ret _ expr -> genExpr expr >> addLines ["leave", "ret"] >> return id

  VRet _ -> addLines ["leave", "ret"] >> return id

  Cond _ expr innerStmt -> do
    genExpr expr
    curBlock <- curBlockCounter
    let curIf = "__if_" ++ curBlock ++ "_end"
    addLines ["cmp $0, %eax", "je " ++ curIf]
    local nextPrefix $ genStmt innerStmt
    addLine $ curIf ++ ":"
    return id

  CondElse _ expr stmt1 stmt2 -> do
    genExpr expr
    curBlock <- curBlockCounter
    let curIf = "__if_" ++ curBlock
    addLines ["cmp $0, %eax", "je " ++ curIf ++ "_else"]
    local nextPrefix $ genStmt stmt1
    addLines ["jmp " ++ curIf ++ "_end", curIf ++ "_else:"]
    local nextPrefix $ genStmt stmt2
    addLine $ curIf ++ "_end:"
    return id

  While _ expr innerStmt  -> do
    curBlock <- curBlockCounter
    let curWhile = "__while_" ++ curBlock
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
      let loc' = (show loc) ++ "(%ebp)"
      case item of
        NoInit _ x -> do
          auxLine <- setDefaultValue varType
          addLine $ auxLine ++ loc'
          saveVarOnStack x varType
        Init _ x expr -> do
          genExpr expr
          case varType of
            _ -> addLine ("movl %eax, " ++ loc')
          saveVarOnStack x varType

