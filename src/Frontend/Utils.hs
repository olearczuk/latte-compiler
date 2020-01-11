module Frontend.Utils where

import Control.Monad.Reader
import Control.Monad.Except
import Control.Monad.State
import Data.Maybe
import Grammar.AbsLatte
import Grammar.PrintLatte
import qualified Data.Map as M
import Data.List

type InstrPos = Maybe (Int, Int)
type TType = Type InstrPos
type IItem = Item InstrPos
type ExpectedTypes = [TType]
type BlockNumber = Integer
type VarsCounter = Integer
type FunctionData = (TType, [Arg InstrPos])
type Expression = Expr InstrPos
type Statement = Stmt InstrPos
type LLValue = LValue InstrPos
type CClMember = ClMember InstrPos
type ArgToAddress = (M.Map Ident (Int, TType))
type AreReturnsSatisified = Bool

type FuncWithData = (TopDef InstrPos, VarsCounter, ArgToAddress)
type FunctionsRetTypes = M.Map Ident TType
type StringConstants = M.Map String String
type ClassesInfo = M.Map Ident ArgToAddress

builtInFunctions :: [Ident]
builtInFunctions = [Ident "printInt", Ident "printString", Ident "error",
                    Ident "readInt", Ident "readString", Ident "compareStrings", Ident "emptyString", Ident "allocateMemory"]

builtInFunctionsTypes :: FunctionsRetTypes
builtInFunctionsTypes = M.fromList [(Ident "printInt", vVoid), (Ident "printString", vVoid), (Ident "error", vVoid),
                                  (Ident "readInt", iInt), (Ident "readString", sString)]

iInt :: TType
sString :: TType
bBool :: TType
vVoid :: TType
cClass :: TType
iInt = Int Nothing
sString = Str Nothing
bBool = Bool Nothing
vVoid = Void Nothing
cClass = Class Nothing (Ident "")

comparableTypes :: ExpectedTypes
comparableTypes = [iInt, sString, bBool, cClass]

varTypes :: ExpectedTypes
varTypes = [iInt, sString, bBool, cClass]

data Env = Env {
  variables :: M.Map Ident (TType, BlockNumber),
  functions :: M.Map Ident FunctionData,
  classes :: ClassesInfo,
  actFunctionType :: TType,
  blockNumber :: Integer,
  argToAddress :: ArgToAddress,
  actClass :: Ident
}

initEnv :: Env
initEnv = Env { variables = M.empty, functions = M.empty,
                classes = M.empty, blockNumber = 0, 
                actFunctionType = iInt, argToAddress = M.empty,
                actClass = Ident "" }

data Store = Store {
  localVarsCounter :: Integer,
  stringConstants :: StringConstants
}

initStore :: Store
initStore = Store { localVarsCounter = 0, stringConstants = M.empty }

type Frontend a = (StateT Store (ReaderT Env (Except String))) a

extractLineColumn :: (Print a) => a -> InstrPos -> String
extractLineColumn ins pos =
  let (line, column) = fromJust pos in
  (show line) ++ ":" ++ (show column) ++ ": " ++ (printTree ins)

lookupVariableType :: Ident -> InstrPos -> Frontend TType
lookupVariableType x pos = do
  vars <- asks variables
  let val = M.lookup x vars
  case val of 
    Nothing ->  throwError $ (extractLineColumn x pos) ++ " no such variable"
    Just (v, blockNumber) -> return v

lookupFunctionData :: Ident -> InstrPos -> Frontend FunctionData
lookupFunctionData f pos = do
  functions <- asks functions
  let functionData = M.lookup f functions
  case functionData of
    Nothing -> throwError $ (extractLineColumn f pos) ++ " no such function"
    Just fData -> return fData

nextBlockNumber :: Env -> Env
nextBlockNumber env = env { blockNumber = 1 + blockNumber env }

checkIfExactSameType :: (Print a) =>  TType -> TType -> InstrPos -> a -> Frontend ()
checkIfExactSameType (Class _ id1) (Class _ id2) pos instr =
  if id1 == id2
    then return ()
    else throwError $ (extractLineColumn instr pos) ++ " wrong type"
checkIfExactSameType t2 t1 pos instr = checkType t2 [t1] pos instr

isSameType :: TType -> TType -> Bool
isSameType (Int _) (Int _) = True
isSameType (Void _) (Void _) = True
isSameType (Str _) (Str _) = True
isSameType (Bool _) (Bool _) = True
isSameType (Class _ _) (Class _ _) = True
isSameType _ _ = False

checkType :: (Print a) => TType -> ExpectedTypes -> InstrPos -> a -> Frontend ()
checkType t types pos instruction =
  case find (isSameType t) types of
    Just _ -> return ()
    Nothing -> throwError $ (extractLineColumn instruction pos) ++ " wrong type"

checkIfVariableDefined :: (Print a) => Ident -> InstrPos -> a -> Frontend ()
checkIfVariableDefined x pos instruction = do
  vars <- asks variables
  actBlockNumber <- asks blockNumber
  let val = M.lookup x vars
  case val of
    Just (_, blockNumber) ->
      if blockNumber == actBlockNumber
        then throwError $ (extractLineColumn instruction pos) ++ " is already defined"
        else return ()
    Nothing -> return ()

addVariable :: Ident -> TType -> Frontend (Env -> Env)
addVariable x varType = do
  blockNumber <- asks blockNumber
  return $ \env ->
        let newVariables = M.insert x (varType, blockNumber) (variables env) in
        env { variables = newVariables }

checkIfFunctionDefined :: (Print a) => Ident -> InstrPos -> a -> Frontend ()
checkIfFunctionDefined f pos instruction = do
  if f `elem` builtInFunctions
    then throwError $ (extractLineColumn instruction pos) ++ " built in function"
  else do
    functions <- asks functions
    let functionData = M.lookup f functions
    case functionData of
      Just _ ->
        throwError $ (extractLineColumn instruction pos) ++ " function is already defined"
      Nothing -> return ()

addStrConstant :: String -> Frontend ()
addStrConstant s = do
  strConst <- gets stringConstants
  case M.lookup s strConst of
    Nothing -> do
      let strConst' = M.insert s ("LC" ++ (show $ M.size strConst)) strConst
      modify $ \store -> store {stringConstants = strConst'}
    Just _ -> return ()

getPosFromType :: TType -> Maybe (Int, Int)
getPosFromType tType = 
  case tType of
    Int pos -> pos
    Str pos -> pos
    Bool pos -> pos
    Void pos -> pos

getClassFieldType :: TType -> LLValue -> Frontend TType
getClassFieldType (Class _ classId) (ObjField pos lval x) = do
  classInfo <- getClassInfo classId pos
  case M.lookup x classInfo of
    Nothing -> throwError $ (extractLineColumn (Class pos classId) pos) ++
      " class has no field " ++ (printTree x)
    Just (_, xType) -> return xType

getClassInfo :: Ident -> InstrPos -> Frontend ArgToAddress
getClassInfo id pos = do
  cl <- asks classes
  case M.lookup id cl of
    Nothing -> throwError $ (extractLineColumn id pos) ++ " no such class"
    Just classInfo -> return classInfo

checkIfClassDefined :: Ident -> InstrPos -> Frontend ()
checkIfClassDefined id pos = do
  cl <- asks classes
  case M.lookup id cl of
    Nothing -> return ()
    Just classInfo -> throwError $ (extractLineColumn id pos) ++ " class is already defined"

addNewFieldToClass :: CClMember -> Frontend (Env -> Env)
addNewFieldToClass member = do
  let (ClField pos xType x) = member
  actClass_ <- asks actClass
  classes_ <- asks classes
  let toAddress = fromJust $ M.lookup actClass_ classes_
  let xLoc = 4 * M.size toAddress
  case M.lookup x toAddress of
    Nothing -> return $ \env -> 
      env { classes = M.insert actClass_ (M.insert x (xLoc, xType) toAddress) classes_}
    Just _ -> throwError $ (extractLineColumn member pos) ++ " is already defined"
-- checkIfClass :: TType -> Frontend ()
-- checkIfClass t =
--   case t of
--     Class pos ident -> do
--       cl <- asks classes
--       case M.lookup ident cl of
--         Nothing -> throwError $ (extractLineColumn t pos) ++ " no such class"
--         Just _ -> return ()
--     _ -> throwError $ (extractLineColumn t (getPosFromType t)) ++ " no such class"