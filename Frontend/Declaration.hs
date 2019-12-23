module Frontend.Declaration where

import Frontend.Utils
import Frontend.Statement
import qualified Data.Map as M
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Except
import Grammar.AbsLatte

checkDecls :: [TopDef InstrPos] -> Frontend [FuncWithData]
checkDecls topDefs = do
  f <- execDecls topDefs
  local f $ checkFunctionsBody topDefs

execDecls :: [TopDef InstrPos] -> Frontend (Env -> Env)
execDecls [] = do
  checkStmt $ SExp Nothing (EApp (Just (0, 0)) (Ident "main") [])
  env <- ask
  return $ \_ -> env
execDecls (topDef:topDefT) = do
  declResult <- execDecl topDef
  declResult' <- local declResult $ execDecls topDefT
  return declResult'

execDecl :: TopDef InstrPos -> Frontend (Env -> Env)
execDecl (FnDef pos fType f args stmt) = do
  checkIfFunctionDefined f pos (FnDef pos fType f args stmt)
  actEnv <- ask

  let newEnv = actEnv { functions = M.insert f (fType, args) $ functions actEnv }
  return $ \_ -> newEnv

checkFunctionsBody :: [TopDef InstrPos] -> Frontend [FuncWithData]
checkFunctionsBody [] = return []
checkFunctionsBody (FnDef pos fType f args stmt:fnDefT) = do
  (fType, fArgs) <- lookupFunctionData f pos
  modify $ \store -> store { localVarsCounter = 0, argToAddress = M.empty}
  fArgs <- initArguments fArgs
  (_, wasReturn) <- local (\env -> fArgs $ env { actFunctionType = fType }) $ 
                      checkStmt $ BStmt Nothing $ stmt
  if wasReturn == False && (isSameType fType (Void Nothing)) == False
    then
      throwError $ extractLineColumn f pos ++ " missing returns"
    else do
      counter <- gets localVarsCounter
      toAddress <- gets argToAddress
      tail <- checkFunctionsBody fnDefT
      return ((FnDef pos fType f args stmt, counter, toAddress):tail)

initArguments :: [Arg InstrPos] -> Frontend (Env -> Env)
initArguments [] = do
  vars <- asks variables
  return $ \env -> env { variables = vars }
initArguments ((Arg pos argType argId):argsT) = do
  f <- execSingleVarDecl (NoInit pos argId) argType
  toAddress <- gets argToAddress
  let mapSize = M.size toAddress
  modify $ \store -> store { 
    argToAddress = M.insert argId (8 + mapSize * 4, argType) toAddress }
  local f $ initArguments argsT