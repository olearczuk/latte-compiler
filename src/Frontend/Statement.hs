module Frontend.Statement where

import Grammar.AbsLatte
import Frontend.Utils
import Frontend.Expression
import Common.Utils
import Control.Monad.Reader
import Control.Monad.State

checkStmts :: [Statement] -> Frontend ((Env -> Env), AreReturnsSatisified)
checkStmts stmts = checkStmtsAux stmts False
  where
    checkStmtsAux :: [Statement] -> Bool -> Frontend ((Env -> Env), AreReturnsSatisified)
    checkStmtsAux [] acc = return (id, acc)
    checkStmtsAux (stmt:stmtT) acc = do
      (stmtResult, wasReturn) <- checkStmt stmt
      local stmtResult $ checkStmtsAux stmtT (acc || wasReturn)

checkStmt :: Statement -> Frontend ((Env -> Env), AreReturnsSatisified)
checkStmt stmt = case stmt of
  Empty _ -> return (id, False)

  BStmt _ (Block _ stmts) ->
    local nextBlockNumber $ checkStmts stmts

  Decl pos varType items ->
    case items of
      [] -> do
        actEnv <- ask
        return (\env -> actEnv, False)
      (itemsH:itemsT) -> do
        modify $ \store -> store {localVarsCounter = localVarsCounter store + 1}
        f <- execSingleVarDecl itemsH varType
        local f $ checkStmt (Decl pos varType itemsT)

  Ass pos lval expr -> do
    t <- getExprType $ ELValue Nothing lval
    exprType <- getExprType expr
    let exprPos = getExprPos expr
    checkIfAssignable t exprType exprPos expr
    return (id, False)

  Incr pos lval -> do
    t <- getExprType $ ELValue Nothing lval
    checkType t [iInt] pos lval
    return (id, False)

  Decr pos lval -> do
    t <- getExprType $ ELValue Nothing lval
    checkType t [iInt] pos lval
    return (id, False)

  Ret pos expr -> do
    exprType <- getExprType expr
    let exprPos = getExprPos expr
    fType <- asks actFunctionType
    checkType exprType [fType] exprPos expr
    return (id, True)

  VRet pos -> do
    fType <- asks actFunctionType
    checkType fType [vVoid] pos stmt
    return (id, True)

  Cond pos expr stmt -> local nextBlockNumber $ do
    exprType <- getExprType expr
    let exprPos = getExprPos expr
    checkType exprType [bBool] exprPos expr
    (_, wasReturn) <- checkStmt stmt
    case expr of
      ELitTrue _ -> return (id, wasReturn)
      _ -> return (id, False)

  CondElse pos expr stmt1 stmt2 -> local nextBlockNumber $ do
    exprType <- getExprType expr
    let exprPos = getExprPos expr
    checkType exprType [bBool] exprPos expr
    (_, wasReturn1) <- checkStmt stmt1
    (_, wasReturn2) <- checkStmt stmt2
    let wasReturn = case expr of
          ELitTrue _ -> wasReturn1
          ELitFalse _ -> wasReturn2
          _ -> wasReturn1 && wasReturn2
    return (id, wasReturn)

  While pos expr stmt -> local nextBlockNumber $ do
    exprType <- getExprType expr
    let exprPos = getExprPos expr
    checkType exprType [bBool] exprPos expr
    checkStmt stmt
    case expr of
      ELitTrue _ -> return (id, True)
      _ -> return (id, False)

  SExp _ expr ->
    getExprType expr >> return (id, False)


execSingleVarDecl :: IItem -> TType -> Frontend (Env -> Env)
execSingleVarDecl item varType =
  checkType varType varTypes (getPosFromType varType) varType >>
  case item of
    NoInit pos x -> do
      checkIfVariableDefined x pos item
      addVariable x varType
    Init pos x expr -> do
      checkIfVariableDefined x pos item
      exprType <- getExprType expr
      let exprPos = getExprPos expr
      checkIfAssignable varType exprType exprPos expr
      addVariable x varType