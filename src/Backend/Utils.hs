module Backend.Utils where

import Grammar.AbsLatte
import Control.Monad.State
import Control.Monad.Reader
import Control.Monad.Writer
import qualified Data.Map as M
import Data.Maybe
import qualified Data.DList as DL
import Common.Utils

data Env = Env {
  fRetTypes :: FunctionsRetTypes,
  variables :: VarToAddress,
  classes :: ClassesInfo,
  linePrefix :: String,
  stringConstants :: StringConstants
}

data Store = Store { 
  auxBlockCounter :: Integer,
  curLoc :: Int
}

initEnv :: FunctionsRetTypes -> (M.Map String String) -> ClassesInfo -> Env
initEnv fRetTypes strConsts classes_ = 
  Env { fRetTypes = fRetTypes, variables = M.empty, 
        linePrefix="", stringConstants = strConsts, classes = classes_ }
initStore :: Store
initStore = Store { auxBlockCounter = 0, curLoc = 0 }

type Backend a = (StateT Store (ReaderT Env (Writer (DL.DList String)))) a

getVarInfo :: Ident -> Backend (String, TType)
getVarInfo x = do
  vars <- asks variables
  case M.lookup x vars of
    Just (varPos, varType) -> return ((show varPos) ++ "(%ebp)", varType)
    Nothing -> do
      let (selfPos, Class _ selfClass) = fromJust $ M.lookup (Ident "self") vars
      addLine $ "movl " ++ (show selfPos) ++ "(%ebp), %ecx"
      (fieldPos, fieldType) <- getFieldLoc selfClass x
      return ((show fieldPos) ++ "(%ecx)", fieldType)

addLine :: String -> Backend ()
addLine line = do
  prefix <- asks linePrefix
  tell $ DL.singleton (prefix ++ line ++ "\n")

addLines :: [String] -> Backend ()
addLines [] = return ()
addLines (h:t) = addLine h >> addLines t

getFunctionType :: Ident -> Backend TType
getFunctionType f = do
  fMap <- asks fRetTypes
  return $ fromJust $ M.lookup f fMap

curBlockCounter :: Backend String
curBlockCounter = do
  counter <- gets auxBlockCounter
  modify $ \store -> store { auxBlockCounter = counter + 1}
  return $ show counter

pushEax :: Backend ()
pushEax = addLine "pushl %eax"

popEcx :: Backend ()
popEcx = addLine "popl %ecx"

getCurLoc :: Backend Int
getCurLoc = do
  loc <- gets curLoc
  modify $ \store -> store { curLoc = loc - 4 }
  return $ loc - 4

saveVarOnStack :: Ident -> TType -> Backend (Env -> Env)
saveVarOnStack x varType = do
  loc <- gets curLoc
  return $ \env -> env { variables = M.insert x (loc, varType) $ variables env }

getVarLoc :: Ident -> Backend String
getVarLoc x = do
  vars <- asks variables
  case M.lookup x vars of
    Just (loc, _) -> return $ (show loc) ++ "(%ebp)"
    Nothing -> do
      let (selfPos, Class _ selfClass) = fromJust $ M.lookup (Ident "self") vars
      addLine $ "movl " ++ (show selfPos) ++ "(%ebp), %ecx"
      (fieldPos, _) <- getFieldLoc selfClass x
      return $ (show fieldPos) ++ "(%ecx)"

nextPrefix :: (Env -> Env)
nextPrefix = \env -> env { linePrefix = linePrefix env ++ "  " }

getStrConst :: String ->  Backend String
getStrConst s = do
  strConsts <- asks stringConstants
  return $ fromJust $ M.lookup s strConsts

setDefaultValue :: TType -> Backend String
setDefaultValue t =
  case t of
    Str _ -> addLine "call emptyString" >> return "movl %eax, "
    _ -> return "movl $0, "

getFieldLoc :: Ident -> Ident -> Backend (VarPos, TType)
getFieldLoc classId x = do
  classes_ <- asks classes
  let toAddress = fields $ fromJust $ M.lookup classId classes_
  return $ fromJust $ M.lookup x toAddress

getVtableIndex :: Ident -> Ident -> Backend Int
getVtableIndex classId methodId = do
  classes_ <- asks classes
  let vtableIndex_ = vtableIndex $ fromJust $ M.lookup classId classes_
  return $ fromJust $ M.lookup methodId vtableIndex_

getMethodType :: Ident -> Ident -> Backend TType
getMethodType classId methodId = do
  classes_ <- asks classes
  let methods_ = methods $ fromJust $ M.lookup classId classes_
  let (_, fType, _) = fromJust $ M.lookup methodId methods_
  return fType