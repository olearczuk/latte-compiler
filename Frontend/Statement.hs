module Frontend.Statement where

import Grammar.AbsLatte
import Frontend.Utils
import Frontend.Expression

checkStmts :: [Statement] -> Frontend (Env -> Env)
checkStmts [] = return id

checkStmts (stmt:stmtT) = do
	stmtResult <- checkStmt stmt
	local stmtResult $ checkStmts stmtT

checkStmt :: Statement -> Frontend (Env -> Env)
checkStmt stmt = case stmt of
  Empty _ -> return id

  BStmt pos (Block stmts) ->
    local nextBlockNumber $ checkStmts stmts

  -- Decl pos varType items ->
  --   case items of
  --     [] -> do
  --       actEnv <- asks
  --       return $ \env -> actEnv
  --     (itemsH:itemsT) -> do
  --       f <- execSingleVarDecl varType itemsH
  --       local f $ execSingleVarDecl (Decl pos varType itemsT)


  Ass pos x expr -> do
    t <- lookupVariableType x pos
    exprType <- getExprType expr
    checkType exprType [t] pos stmt
    return id

  Incr pos x -> do
    t <- lookupVariableType x pos
    checkType t [IInt] pos stmt
    return id

  Decr pos x -> do
    t <- lookupVariableType x pos
    checkType t [IInt] pos stmt
    return id

  Ret pos expr -> do
    exprType <- getExprType expr
    fType <- asks actFunctionType
    checkType expr [fType] pos stmt
    return id

  VRet pos -> do
    fType <- asks actFunctionType
    checkType fType [VVoid] pos stmt
    return id

  Cond pos expr stmt -> local nextBlockNumber $ do
    exprType <- getExprType
    checkType Bool exprType pos expr
    checkStmt stmt
    return id

  ElseCond pos expr stmt1 stmt2 -> local nextBlockNumber $ do
    exprType <- getExprType
    checkType Bool exprType pos expr
    checkStmt stmt1
    checkStmt stmt2
    return id

  While pos expr stmt -> local nextBlockNumber $ do
    exprType <- getExprType
    checkType Bool exprType pos expr
    checkStmt stmt

  SExp _ expr ->
    getExprType expr >> return id


  -- where
  --   execSingleVarDecl :: Item -> TT