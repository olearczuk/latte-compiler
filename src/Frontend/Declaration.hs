module Frontend.Declaration where

import Frontend.Utils
import Frontend.Statement
import qualified Data.Map as M
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Except
import Grammar.AbsLatte

checkDecls :: [TopDef InstrPos] -> Frontend ([FuncWithData], FunctionsRetTypes, StringConstants, ClassesInfo)
checkDecls topDefs = do
  f <- execDecls topDefs
  local f $ checkTopDefBody topDefs
  where 
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
    execDecl (FnDef pos fType f args _) = do
      checkIfFunctionDefined f pos f
      return $ \env -> env { 
        functions = M.insert f (fType, args) $ functions env }
    execDecl (ClDef pos classId extends members) = do
      checkIfClassDefined classId pos
      local (\env -> env { actClass = classId, 
          classes = M.insert classId M.empty $ classes env}) $ prepClassMembers members

    prepClassMembers :: [ClMember InstrPos] -> Frontend (Env -> Env)
    prepClassMembers [] = do
      actEnv <- ask
      return $ \env -> actEnv
    prepClassMembers ((ClField pos t x):membersT) = do
      f <- addNewFieldToClass (ClField pos t x)
      local f $ prepClassMembers membersT
    -- TODO prepClassMembers ((CLMethod ...):membersT)

    initArguments :: [Arg InstrPos] -> Frontend ((Env -> Env), ArgToAddress)
    initArguments [] = do
      vars <- asks variables
      toAddress <- asks argToAddress
      return (\env -> env { variables = vars }, toAddress)
    initArguments ((Arg pos argType argId):argsT) = do
      f <- execSingleVarDecl (NoInit pos argId) argType
      toAddress <- asks argToAddress
      let mapSize = M.size toAddress
      let newArgFunction = \env -> env { 
        argToAddress = M.insert argId (8 + mapSize * 4, argType) toAddress }
      local (f . newArgFunction) $ initArguments argsT

    checkTopDefBody :: [TopDef InstrPos] -> Frontend ([FuncWithData], FunctionsRetTypes, StringConstants, ClassesInfo)
    checkTopDefBody [] = do
      classes_ <- asks classes
      stringConsts <- gets stringConstants
      return ([], builtInFunctionsTypes, stringConsts, classes_)
    checkTopDefBody (FnDef pos fType f args stmt:fnDefT) = do
      (fType, fArgs) <- lookupFunctionData f pos
      modify $ \store -> store { localVarsCounter = 0 }
      (fArgsFunc, toAddress) <- initArguments fArgs
      (_, wasReturn) <- local (\env -> fArgsFunc $ env { actFunctionType = fType }) $ 
                          checkStmt $ BStmt Nothing $ stmt
      if wasReturn == False && (isSameType fType (Void Nothing)) == False
        then
          throwError $ extractLineColumn f pos ++ " missing returns"
        else do
          counter <- gets localVarsCounter
          (funcWithData, funcTypes, stringConsts, classes_) <- checkTopDefBody fnDefT
          return ((FnDef pos fType f args stmt, counter, toAddress):funcWithData, 
            M.insert f fType funcTypes, stringConsts, classes_)
    checkTopDefBody (_:fnDefT) = checkTopDefBody fnDefT