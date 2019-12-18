module Frontend.Utils where

import Control.Monad.Reader
import Control.Monad.Except
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
type ArgsData = [(TType, Ident)]
type FunctionData = (TType, ArgsData)
type Expression = Expr InstrPos
type Statement = Stmt InstrPos

builtInFunctions :: [Ident]
builtInFunctions = [Ident "printInt", Ident "printString", Ident "error",
                    Ident "readInt", Ident "readString"]

iInt :: TType
sString :: TType
bBool :: TType
vVoid :: TType
iInt = Int Nothing
sString = Str Nothing
bBool = Bool Nothing
vVoid = Void Nothing 

comparableTypes :: ExpectedTypes
comparableTypes = [iInt, sString, bBool]

data Env = Env {
  variables :: M.Map Ident (TType, BlockNumber),
  functions :: M.Map Ident FunctionData,
  actFunctionType :: TType,
  blockNumber :: Integer
}

initEnv :: Env
initEnv = Env { variables = M.empty, functions = M.empty, 
                blockNumber = 0, actFunctionType = iInt }

type Frontend a = (ReaderT Env (Except String)) a

extractLineColumn :: InstrPos -> String
extractLineColumn pos =
  let (line, column) = fromJust pos in
  (show line) ++ ":" ++ (show column) ++ ": "

lookupVariableType :: Ident -> InstrPos -> Frontend TType
lookupVariableType x pos = do
  vars <- asks variables
  let val = M.lookup x vars
  case val of 
    Nothing ->  throwError $ (extractLineColumn pos) ++ 
      "variable " ++ (printTree x) ++ " is not defined"
    Just (v, blockNumber) -> return v

lookupFunctionData :: Ident -> InstrPos -> Frontend FunctionData
lookupFunctionData f pos = do
  functions <- asks functions
  let functionData = M.lookup f functions
  case functionData of
    Nothing -> throwError $ (extractLineColumn pos) ++ 
      "function " ++ (printTree f) ++ " is not defined"
    Just fData -> return fData

nextBlockNumber :: Env -> Env
nextBlockNumber env = env { blockNumber = 1 + blockNumber env }

isSameType :: TType -> TType -> Bool
isSameType (Int _) (Int _) = True
isSameType (Void _) (Void _) = True
isSameType (Str _) (Str _) = True
isSameType (Bool _) (Bool _) = True
isSameType _ _ = False

checkType :: (Print a) => TType -> ExpectedTypes -> InstrPos -> a -> Frontend ()
checkType t types pos instruction =
  case find (isSameType t) types of
    Just _ -> return ()
    Nothing -> throwError $ (extractLineColumn pos) ++ (printTree instruction) ++ " wrong type"

checkIfVariableDefined :: (Print a) => Ident -> InstrPos -> a -> Frontend ()
checkIfVariableDefined x pos instruction = do
  vars <- asks variables
  actBlockNumber <- asks blockNumber
  let val = M.lookup x vars
  case val of
    Just (_, blockNumber) ->
      if blockNumber == actBlockNumber
        then throwError $ (extractLineColumn pos) ++ (printTree instruction) ++ "is already defined"
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
    then throwError $ (extractLineColumn pos) ++ (printTree instruction) ++ " built in function"
  else do
    functions <- asks functions
    let functionData = M.lookup f functions
    case functionData of
      Just _ ->
        throwError $ (extractLineColumn pos) ++ (printTree instruction) ++ " function is already defined"
      Nothing -> return ()