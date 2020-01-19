module Frontend.Declaration where

import Frontend.Declaration_classes
import Frontend.Utils
import Frontend.Statement
import qualified Data.Map as M
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Except
import Grammar.AbsLatte
import Common.Utils
import Data.Maybe

checkDecls :: [TopDef InstrPos] -> Frontend FrontendResult
checkDecls topDefs = do
  let funcDefs = filter (isFunction) topDefs
  let classDefs = filter (not . isFunction) topDefs
  f <- execFuncDecls funcDefs
  f' <- local f $ execClassDecls classDefs
  local f' $ checkTopDefs topDefs
  where 
    execFuncDecls :: [TopDef InstrPos] -> Frontend (Env -> Env)
    execFuncDecls [] = do
      checkStmt $ SExp Nothing (EApp (Just (0, 0)) (Ident "main") [])
      env <- ask
      return $ \_ -> env
    execFuncDecls ((FnDef pos fType f args _):topDefT) = do
      checkIfFunctionDefined f pos f
      let declFunc = \env -> env { 
        functions = M.insert f (fType, args) $ functions env 
      }
      declResult' <- local declFunc $ execFuncDecls topDefT
      return declResult'

    initArguments :: [Arg InstrPos] -> Frontend ((Env -> Env), VarToAddress)
    initArguments [] = do
      vars <- asks variables
      toAddress <- asks varToAddress
      return (\env -> env { variables = vars }, toAddress)
    initArguments ((Arg pos argType argId):argsT) = do
      f <- execSingleVarDecl (NoInit pos argId) argType
      toAddress <- asks varToAddress
      let mapSize = M.size toAddress
      let newArgFunction = \env -> env { 
        varToAddress = M.insert argId (8 + mapSize * 4, argType) toAddress }
      local (f . newArgFunction) $ initArguments argsT

    checkTopDefs :: [TopDef InstrPos] -> Frontend FrontendResult
    checkTopDefs [] = do
      classes_ <- asks classes
      stringConsts <- gets stringConstants
      return $ initFrontendResult builtInFunctionsTypes stringConsts classes_
    checkTopDefs (FnDef pos fType f args stmt:fnDefT) = do
      let funcDef = (FnDef pos fType f args stmt)
      (counter, toAddress) <- checkFuncBody funcDef
      frontResult <- checkTopDefs fnDefT
      return $ frontResult {
        funcWithData = 
          ((funcDef, counter, toAddress):funcWithData frontResult),
        funcRetTypes = M.insert f fType $ funcRetTypes frontResult
      }
    checkTopDefs (ClDef pos classId _ members:fnDefT) = do
      f <- local (\env -> env { actClass = classId }) $ checkMembers members
      frontResult <- checkTopDefs fnDefT
      return $ f frontResult

    checkMembers :: [ClMember InstrPos] -> Frontend (FrontendResult -> FrontendResult)
    checkMembers [] = return id
    checkMembers (ClField _ _ _:membersT) = checkMembers membersT
    checkMembers (ClMethod pos fType f args stmt:membersT) = do
      classId <- asks actClass
      let args' = (Arg pos (Class pos classId) (Ident "self"):args)
      (counter, toAddress) <- checkFuncBody (FnDef pos fType f args' stmt)
      tailF <- checkMembers membersT
      return $ (\frontResult -> frontResult {
        methodsWithData = ((classId, 
          (FnDef pos fType f args' stmt), counter, toAddress): methodsWithData frontResult)
      }) . tailF

    checkFuncBody :: TopDef InstrPos -> Frontend (Integer, VarToAddress)
    checkFuncBody (FnDef pos fType f args stmt) = do
      modify $ \store -> store { localVarsCounter = 0 }
      (fArgsFunc, toAddress) <- initArguments args
      (_, wasReturn) <- local (\env -> fArgsFunc $ env { actFunctionType = fType }) $ 
                          checkStmt $ BStmt Nothing $ stmt
      counter <- gets localVarsCounter
      if wasReturn == False && (isSameType fType (Void Nothing)) == False
        then throwError $ extractLineColumn f pos ++ " missing returns"
        else return (counter, toAddress)


    isFunction :: TopDef InstrPos -> Bool
    isFunction (FnDef _ _ _ _ _) = True
    isFunction _ = False