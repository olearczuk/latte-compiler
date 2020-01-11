module Backend.Utils where

import Grammar.AbsLatte
import Control.Monad.State
import Control.Monad.Reader
import Control.Monad.Writer
import qualified Data.Map as M
import Data.Maybe
import qualified Data.DList as DL

type InstrPos = Maybe (Int, Int)
type VarsCounter = Integer
type VarPos = Int
type TType = Type InstrPos
type IItem = Item InstrPos
type ArgToAddress = (M.Map Ident (VarPos, TType))
type FuncWithData = (TopDef InstrPos, VarsCounter, ArgToAddress)
type FunctionsRetTypes = M.Map Ident TType
type Expression = Expr InstrPos
type Statement = Stmt InstrPos
type StringConstants = M.Map String String
type ClassesInfo = M.Map Ident ArgToAddress

iInt :: TType
sString :: TType
bBool :: TType
iInt = Int Nothing
sString = Str Nothing
bBool = Bool Nothing

data Env = Env {
  fRetTypes :: FunctionsRetTypes,
  variables :: ArgToAddress,
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

getVarInfo :: Ident -> Backend (VarPos, TType)
getVarInfo x = do
  vars <- asks variables
  return $ fromJust $ M.lookup x vars

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
  let loc = fst $ fromJust $ M.lookup x vars
  return $ (show loc) ++ "(%ebp)"

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
  let toAddress = fromJust $ M.lookup classId classes_
  return $ fromJust $ M.lookup x toAddress