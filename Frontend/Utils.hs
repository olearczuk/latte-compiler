module Frontend.Utils where

import Control.Monad.Reader
import Control.Monad.Except
import Data.Maybe
import Grammar.AbsLatte
import Grammar.PrintLatte
import qualified Data.Map as M

data TType = IInt | SString | BBool | VVoid deriving Eq

type ExpectedTypes = [TType]
type BlockNumber = Integer
type ArgsData = [TType]
type FunctionData = (TType, ArgsData)
type Expression = Expr (Maybe (Int, Int))
type Statement = Stmt (Maybe (Int, Int))

builtInFunctions :: [Ident]
builtInFunctions = [Ident "printInt", Ident "printString", Ident "error",
                    Ident "readInt", Ident "readString"]

comparableTypes :: ExpectedTypes
comparableTypes = [IInt, SString, BBool]

data Env = Env {
  variables :: M.Map Ident (TType, BlockNumber),
  functions :: M.Map Ident FunctionData,
  actFunctionType :: TType,
  blockNumber :: Int
}

initEnv :: Env
initEnv = Env { variables = M.empty, functions = M.empty, 
                blockNumber = 0, actFunctionType = IInt }

type Frontend a = (ReaderT Env (Except String)) a

extractLineColumn :: (Maybe (Int, Int)) -> String
extractLineColumn pos =
  let (line, column) = fromJust pos in
  (show line) ++ ":" ++ (show column) ++ ": "

lookupVariableType :: Ident -> (Maybe (Int, Int)) -> Frontend TType
lookupVariableType x pos = do
  vars <- asks variables
  let val = M.lookup x vars
  case val of 
    Nothing ->  throwError $ (extractLineColumn pos) ++ 
      "variable " ++ (printTree x) ++ " is not defined"
    Just (v, blockNumber) -> return v

lookupFunctionData :: Ident -> (Maybe (Int, Int)) -> Frontend FunctionData
lookupFunctionData f pos = do
  functions <- asks functions
  let functionData = M.lookup f functions
  case functionData of
    Nothing -> throwError $ (extractLineColumn pos) ++ 
      "function " ++ (printTree f) ++ " is not defined"
    Just fData -> return fData

nextBlockNumber :: Env -> Env
nextBlockNumber env = env { blockNumber = 1 + blockNumber env }

checkType :: (Print) a => TType -> ExpectedTypes -> (Maybe (Int, Int))-> a -> Frontend ()
checkType t types pos instruction =
  if elem t types
    then return ()
    else throwError $ (extractLineColumn pos) ++ (printTree instruction) ++ " wrong type"