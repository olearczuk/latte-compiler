module Frontend.Declaration where

import Frontend.Utils
import Frontend.Statement
import qualified Data.Map as M
import Control.Monad.Reader
import Control.Monad.State
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

  let functionArgs = map (\(Arg _ argType argId) -> (argType, argId)) args
  let newEnv = actEnv { functions = M.insert f (fType, functionArgs) $ functions actEnv }
  return $ \_ -> newEnv

checkFunctionsBody :: [TopDef InstrPos] -> Frontend [FuncWithData]
checkFunctionsBody [] = return []
checkFunctionsBody (FnDef pos fType f args stmt:fnDefT) = do
  (fType, fArgs) <- lookupFunctionData f pos
  modify $ \store -> store { localVarsCounter = 0 }
  fArgs <- initArguments fArgs
  local (\env -> fArgs $ env { actFunctionType = fType }) $ 
    checkStmt $ BStmt Nothing $ stmt
  counter <- gets localVarsCounter
  tail <- checkFunctionsBody fnDefT
  return ((FnDef pos fType f args stmt, counter):tail)
  -- return tail

initArguments :: [(TType, Ident)] -> Frontend (Env -> Env)
initArguments args = local nextBlockNumber $ initArgumentsAux args id
  where
    initArgumentsAux :: [(TType, Ident)] -> (Env -> Env) -> Frontend (Env -> Env)
    initArgumentsAux [] acc = return acc
    initArgumentsAux ((argType, argId):argsT) acc = do
      f <- execSingleVarDecl (NoInit Nothing argId) argType
      initArgumentsAux argsT $ acc . f