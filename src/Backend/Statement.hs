module Backend.Statement where

import Grammar.AbsLatte
import Grammar.PrintLatte
import Backend.Expression
import Backend.Utils
import Control.Monad.Reader
import Common.Utils

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


  Ass _ lval expr -> do
    genExpr expr
    pushEax
    loc <- getLValLoc lval
    popEcx
    addLine $ "movl %ecx, " ++ loc
    return id

  Incr _ lval -> do
    loc <- getLValLoc lval
    addLine $ "addl $1, " ++ loc
    return id

  Decr _ lval -> do
    loc <- getLValLoc lval
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
    getLValLoc :: LValue InstrPos -> Backend String
    getLValLoc (Var _ x) = getVarLoc x
    getLValLoc (ObjField _ lval x) = do
      exprType <- genExpr $ ELValue Nothing lval
      case exprType of
        Class _ classId -> do
          (varPos, _) <- getFieldLoc classId x
          return $ (show varPos) ++ "(%eax)"

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

