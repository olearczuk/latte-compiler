module Frontend.Declaration_classes where

import Frontend.Utils
import qualified Data.Map as M
import Control.Monad.Reader
import Control.Monad.Except
import Grammar.AbsLatte
import Common.Utils
import Data.Maybe

execClassDecls :: [TopDef InstrPos] -> Frontend (Env -> Env)
execClassDecls classDefs = do
  f <- fillExtends classDefs
  local f $ do
  checkExtendLoops classDefs
  genClassInfo classDefs M.empty
  
  where
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

    genClassInfoAux :: [TopDef InstrPos] -> M.Map Ident Bool -> 
      Frontend (Env -> Env, M.Map Ident Bool)
    genClassInfoAux [] processed = do
      env <- ask
      return (\_ -> env, processed)
    genClassInfoAux (ClDef _ classId (ClNoExt _) members:classDefT) processed = do
      if M.lookup classId processed /= Nothing
        then genClassInfoAux classDefT processed
        else do
          f <- local (\env -> env { actClass = classId }) $ prepClassMembers members
          local f $ genClassInfoAux classDefT $ M.insert classId True processed
    genClassInfoAux (ClDef _ classId (ClExtend _ parentId) members:classDefT) processed =
      case (M.lookup classId processed, M.lookup parentId processed) of
        (Just _, _) -> genClassInfoAux classDefT processed
        (Nothing, Nothing) -> genClassInfoAux classDefT processed
        _ -> do
          classes_ <- asks classes
          let parentInfo = fromJust $ M.lookup parentId classes_
          let actClassInfo = fromJust $ M.lookup classId classes_
          f <- local (\env -> env {
              actClass = classId,
              classes = M.insert classId (actClassInfo {
                fields = fields parentInfo,
                methods = methods parentInfo,
                vtableIndex = vtableIndex parentInfo 
              }) classes_
            }) $ prepClassMembers members
          local f $ genClassInfoAux classDefT $ M.insert classId True processed

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