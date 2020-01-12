module Frontend.Declaration where
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

    execClassDecls :: [TopDef InstrPos] -> Frontend (Env -> Env)
    execClassDecls classDefs = do
      f <- fillExtends classDefs
      local f $ do
        checkExtendLoops classDefs
        genClassInfo classDefs M.empty

    fillExtends :: [TopDef InstrPos] -> Frontend (Env -> Env)
    fillExtends [] = do
      env <- ask
      return $ \_ -> env
    fillExtends (classDef:topDefT) = do
      let (ClDef pos classId extends_ _) = classDef
      checkIfClassDefined classId pos
      local (\env -> env {
        classes = M.insert classId (initClassInfo extends_) $ classes env })
        $ fillExtends $ topDefT

    checkExtendLoops :: [TopDef InstrPos] -> Frontend ()
    checkExtendLoops [] = return ()
    checkExtendLoops ((ClDef _ classId _ _):classDefT) = do
      checkExtendLoopsAux classId M.empty
      checkExtendLoops classDefT 

    checkExtendLoopsAux :: Ident -> M.Map Ident Bool -> Frontend ()
    checkExtendLoopsAux classId visited = do
      case M.lookup classId visited of
        Just _ -> throwError $ "inheritance loop detected"
        Nothing -> do
          classes_ <- asks classes
          let classInfo = fromJust $ M.lookup classId classes_
          case extends classInfo of
            ClNoExt _ -> return ()
            ClExtend pos parentId -> do
              case M.lookup parentId classes_ of
                Nothing -> throwError $ (extractLineColumn (ClExtend pos parentId) pos) ++
                  "class not defined"
                Just _ -> checkExtendLoopsAux parentId $ M.insert classId True visited

    genClassInfo :: [TopDef InstrPos] -> M.Map Ident Bool -> Frontend (Env -> Env)
    genClassInfo classDefs processed = do
      (f, processed') <- genClassInfoAux classDefs processed
      if M.size processed' == length classDefs
        then return f
        else genClassInfo classDefs processed'

    genClassInfoAux :: [TopDef InstrPos] -> M.Map Ident Bool -> Frontend (Env -> Env, M.Map Ident Bool)
    genClassInfoAux [] processed = do
      env <- ask
      return (\_ -> env, processed)
    genClassInfoAux (ClDef _ classId (ClNoExt _) members:classDefT) processed = do
      if checkIfProcessed classId processed
        then genClassInfoAux classDefT processed
        else do
          f <- local (\env -> env { actClass = classId }) $ prepClassMembers members
          local f $ genClassInfoAux classDefT $ M.insert classId True processed
    genClassInfoAux (ClDef _ classId (ClExtend _ parentId) members:classDefT) processed = do
      if checkIfProcessed classId processed
        then genClassInfoAux classDefT processed
        else
          if checkIfProcessed parentId processed == False
            then genClassInfoAux classDefT processed
            else do
              classes_ <- asks classes
              let parentInfo = fromJust $ M.lookup parentId classes_
              let parentFields = fields parentInfo
                  parentMethods = methods parentInfo
                  parentVtableIndex = vtableIndex parentInfo
              let classInfo = fromJust $ M.lookup classId classes_
              f <- local (\env -> env {
                  actClass = classId,
                  classes = M.insert classId 
                    (classInfo { 
                      fields = parentFields, methods = parentMethods,
                      vtableIndex = parentVtableIndex }) classes_
                }) $ prepClassMembers members
              local f $ genClassInfoAux classDefT $ M.insert classId True processed

    checkIfProcessed :: Ident -> M.Map Ident Bool -> Bool
    checkIfProcessed classId processed = 
      case M.lookup classId processed of
        Nothing -> False
        Just _ -> True

    prepClassMembers :: [ClMember InstrPos] -> Frontend (Env -> Env)
    prepClassMembers [] = do
      actEnv <- ask
      return $ \env -> actEnv
    prepClassMembers ((ClField pos t x):membersT) = do
      f <- addNewFieldToClass (ClField pos t x)
      local f $ prepClassMembers membersT
    prepClassMembers ((ClMethod pos fType fId args block):membersT) = do
      f <- addNewMethodToClass ((ClMethod pos fType fId args block))
      local f $ prepClassMembers membersT

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
          frontResult <- checkTopDefs fnDefT
          return $ frontResult {
            funcWithData = ((FnDef pos fType f args stmt, counter, toAddress):funcWithData frontResult),
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
      modify $ \store -> store { localVarsCounter = 0 }
      let args' = (Arg pos (Class pos classId) (Ident "self"):args)
      (fArgsFunc, toAddress) <- initArguments args'
      (_, wasReturn) <- local (\env -> fArgsFunc $ env { actFunctionType = fType }) $
                          checkStmt $ BStmt Nothing $ stmt
      if wasReturn == False && (isSameType fType (Void Nothing)) == False
        then throwError $ extractLineColumn f pos ++ " missing returns"
        else do
          counter <- gets localVarsCounter
          tailF <- checkMembers membersT
          return $ (\frontResult -> frontResult {
            methodsWithData = ((classId, (FnDef pos fType f args' stmt), counter, toAddress): methodsWithData frontResult)
          }) . tailF


    isFunction :: TopDef InstrPos -> Bool
    isFunction (FnDef _ _ _ _ _) = True
    isFunction _ = False