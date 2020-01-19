module Frontend.Utils where

import Control.Monad.Reader
import Control.Monad.Except
import Control.Monad.State
import Data.Maybe
import Grammar.AbsLatte
import Grammar.PrintLatte
import qualified Data.Map as M
import Data.List
import Common.Utils

type ExpectedTypes = [TType]
type BlockNumber = Integer
type FunctionData = (TType, [Arg InstrPos])
type LLValue = LValue InstrPos
type CClMember = ClMember InstrPos
type AreReturnsSatisified = Bool

builtInFunctions :: [Ident]
builtInFunctions = 
  [Ident "printInt", Ident "printString", Ident "error",
   Ident "readInt", Ident "readString", Ident "compareStrings", 
   Ident "emptyString", Ident "allocateMemory"]

builtInFunctionsTypes :: FunctionsRetTypes
builtInFunctionsTypes = 
  M.fromList [(Ident "printInt", vVoid), 
              (Ident "printString", vVoid), (Ident "error", vVoid),
              (Ident "readInt", iInt), (Ident "readString", sString)]

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
  varToAddress :: VarToAddress,
  actClass :: Ident
}

initEnv :: Env
initEnv = Env { variables = M.empty, functions = M.empty,
                classes = M.empty, blockNumber = 0, 
                actFunctionType = iInt, varToAddress = M.empty,
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


--         <<<   FUNCTION RELATED FUNCTIONS   >>>


-- First step is trying to get self.f, in case of failure we get f
lookupMethodFunctionData :: Ident -> InstrPos -> Frontend (Maybe FunctionData)
lookupMethodFunctionData f pos = do
  vars <- asks variables
  case M.lookup (Ident "self") vars of
    Nothing -> do
      fData <- lookupFunctionData f pos
      return $ Just fData
    Just (selfType, _) -> do
      (getClassMethodData selfType f pos >> return Nothing) 
      `catchError`
      (\_ -> do
        fData <- lookupFunctionData f pos
        return $ Just fData)

lookupFunctionData :: Ident -> InstrPos -> Frontend FunctionData
lookupFunctionData f pos = do
  functions <- asks functions
  case M.lookup f functions of
    Nothing -> throwError $ (extractLineColumn f pos) ++ " no such function"
    Just fData -> return fData

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


--         <<<   VARIABLES RELATED FUNCTIONS   >>>


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

-- First step is trying to get x, in case it does not exist, then we try self.x
lookupVariableType :: Ident -> InstrPos -> Frontend TType
lookupVariableType x pos = do
  vars <- asks variables
  let val = M.lookup x vars
  case val of 
    Nothing -> case M.lookup (Ident "self") vars of
      Nothing -> throwError $ (extractLineColumn x pos) ++ " no such variable"
      Just (selfType, _) ->
        getClassFieldType selfType x (Empty Nothing) pos `catchError`
        \_ -> throwError $ (extractLineColumn x pos) ++ " no such variable"
    Just (varType, _) -> return varType


--         <<<   CLASSES RELATED FUNCTIONS   >>>


checkIfClassDefined :: Ident -> InstrPos -> Frontend ()
checkIfClassDefined id pos = do
  cl <- asks classes
  case M.lookup id cl of
    Nothing -> return ()
    Just classInfo -> throwError $ (extractLineColumn id pos) ++ " class is already defined"

getClassInfo :: Ident -> InstrPos -> Frontend ClassInfo
getClassInfo id pos = do
  cl <- asks classes
  case M.lookup id cl of
    Nothing -> throwError $ (extractLineColumn id pos) ++ " no such class"
    Just classInfo -> return classInfo

getClassFieldType :: (Print a) => TType -> Ident -> a -> InstrPos -> Frontend TType
getClassFieldType (Class _ classId) x instr pos = do
  classInfo <- getClassInfo classId pos
  case M.lookup x $ fields classInfo of
    Nothing -> throwError $ (extractLineColumn (Class pos classId) pos) ++
      " class has no field " ++ (printTree x)
    Just (_, xType) -> return xType

addNewFieldToClass :: CClMember -> Frontend (Env -> Env)
addNewFieldToClass member = do
  let (ClField pos xType x) = member
  actClass_ <- asks actClass
  classes_ <- asks classes
  let classInfo = fromJust $ M.lookup actClass_ classes_
  let fields_ = fields classInfo
  let xLoc = 4 + 4 * M.size fields_
  case M.lookup x fields_ of
    Nothing -> return $ \env -> 
      env { classes = M.insert actClass_ 
        (classInfo { fields = M.insert x (xLoc, xType) fields_ })
        classes_}
    Just _ -> throwError $ (extractLineColumn member pos) ++ " is already defined"

getClassMethodData :: TType -> Ident -> InstrPos -> Frontend MethodData
getClassMethodData (Class _ classId) f pos = do
  classInfo <- getClassInfo classId pos
  case M.lookup f $ methods classInfo of
    Nothing -> throwError $ (extractLineColumn (Class pos classId) pos) ++ 
      " class has no method " ++ (printTree f)
    Just methodData -> return methodData

addNewMethodToClass :: CClMember -> Frontend (Env -> Env)
addNewMethodToClass (ClMethod pos fType fId args block) = do
  actClass_ <- asks actClass
  let args' = (Arg pos (Class pos actClass_) (Ident "self")):args
  classes_ <- asks classes
  let classInfo = fromJust $ M.lookup actClass_ classes_
  let methods_ = methods classInfo
  let vtableIndex_ = vtableIndex classInfo

  isOverriding <- checkIfCanOverride (ClMethod pos fType fId args' block)
  if isOverriding
    then return $ \env ->
      env { classes = M.insert actClass_ (
        classInfo { 
          methods = M.insert fId (actClass_, fType, args') methods_
        }) classes_ }
    else return $ \env ->
      env { classes = M.insert actClass_ (
        classInfo {
          methods = M.insert fId (actClass_, fType, args') methods_,
          vtableIndex = M.insert fId (M.size vtableIndex_) vtableIndex_
        }) classes_}
  where
    checkArgTypes :: [Arg InstrPos] -> [Arg InstrPos] -> Ident -> InstrPos -> Frontend ()
    checkArgTypes [] [] _ _ = return ()
    checkArgTypes ((Arg _ argType1 _):argT1) ((Arg argPos argType2 id):argT2) f pos = do 
      checkIfExactSameType argType2 argType1 argPos (Arg argPos argType2 id)
      checkArgTypes argT1 argT2 f pos
    checkArgTypes _ _ f pos =
      throwError $ (extractLineColumn f pos) ++ " wrong number of arguments"

    checkIfCanOverride :: CClMember -> Frontend Bool
    checkIfCanOverride (ClMethod pos fType fId args _) = do
      actClass_ <- asks actClass
      classes_ <- asks classes
      let classInfo = fromJust $ M.lookup actClass_ classes_
      case M.lookup fId $ methods classInfo of
        Nothing -> return False
        Just (prevClass, prevType, prevArgs) ->
          if prevClass == actClass_
            then throwError $ (extractLineColumn fId pos) ++ 
              " is already defined for this class"
            else do
              checkIfAssignable prevType fType pos fType
              checkArgTypes (tail prevArgs) (tail args) fId pos
              return True


--         <<<   TYPE CHECKING RELATED FUNCTIONS   >>>


checkIfAssignable :: (Print a) => TType -> TType -> InstrPos -> a -> Frontend ()
checkIfAssignable (Class _ classId1) (Class _ classId2) pos instr =
  if classId1 == classId2
    then return ()
  else do
    classInfo <- getClassInfo classId2 pos
    case extends classInfo of
      ClNoExt _ -> throwError $ (extractLineColumn instr pos) ++ " wrong type"
      ClExtend _ classId -> 
        checkIfAssignable (Class Nothing classId1) (Class Nothing classId) pos instr
checkIfAssignable t1 t2 pos instr = checkType t2 [t1] pos instr

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
