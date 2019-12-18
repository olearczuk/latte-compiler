module Frontend.Statement where

import Grammar.AbsLatte
import Frontend.Utils
import Frontend.Expression

import Control.Monad.Reader

checkStmts :: [Statement] -> Frontend (Env -> Env)
checkStmts [] = return id

checkStmts (stmt:stmtT) = do
  stmtResult <- checkStmt stmt
  local stmtResult $ checkStmts stmtT

checkStmt :: Statement -> Frontend (Env -> Env)
checkStmt stmt = case stmt of
  Empty _ -> return id

  BStmt _ (Block _ stmts) ->
    local nextBlockNumber $ checkStmts stmts

  Decl pos varType items ->
    case items of
      [] -> do
        actEnv <- ask
        return $ \env -> actEnv
      (itemsH:itemsT) -> do
        f <- execSingleVarDecl itemsH varType
        local f $ checkStmt (Decl pos varType itemsT)


  Ass pos x expr -> do
    t <- lookupVariableType x pos
    exprType <- getExprType expr
    checkType exprType [t] pos stmt
    return id

  Incr pos x -> do
    t <- lookupVariableType x pos
    checkType t [iInt] pos stmt
    return id

  Decr pos x -> do
    t <- lookupVariableType x pos
    checkType t [iInt] pos stmt
    return id

  Ret pos expr -> do
    exprType <- getExprType expr
    fType <- asks actFunctionType
    checkType exprType [fType] pos stmt
    return id

  VRet pos -> do
    fType <- asks actFunctionType
    checkType fType [vVoid] pos stmt
    return id

  Cond pos expr stmt -> local nextBlockNumber $ do
    exprType <- getExprType expr
    checkType exprType [bBool] pos expr
    checkStmt stmt
    return id

  CondElse pos expr stmt1 stmt2 -> local nextBlockNumber $ do
    exprType <- getExprType expr
    checkType exprType [bBool] pos expr
    checkStmt stmt1
    checkStmt stmt2
    return id

  While pos expr stmt -> local nextBlockNumber $ do
    exprType <- getExprType expr
    checkType exprType [bBool] pos expr
    checkStmt stmt

  SExp _ expr ->
    getExprType expr >> return id


execSingleVarDecl :: IItem -> TType -> Frontend (Env -> Env)
execSingleVarDecl item varType =
  case item of
    NoInit pos x -> do
      checkIfVariableDefined x pos item
      addVariable x varType
    Init pos x expr -> do
      checkIfVariableDefined x pos item
      exprType <- getExprType expr
      checkType exprType [varType] pos expr
      addVariable x varType