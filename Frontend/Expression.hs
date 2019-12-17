module Frontend.Expression where

import Frontend.Utils
import Grammar.AbsLatte
import Grammar.PrintLatte
import Control.Monad.Except

getExprType :: Expression -> Frontend TType
getExprType expr = case expr of
  EVar pos x -> lookupVariableType x pos

  ELitInt _ _ -> return IInt

  ELitTrue _ -> return BBool

  ELitFalse _ -> return BBool

  EApp _ (Ident "printInt") exprs ->
    checkArgs exprs [IInt] expr >> return VVoid

  EApp _ (Ident "printString") exprs ->
    checkArgs exprs [SString] expr >> return VVoid

  EApp _ (Ident "error") exprs ->
    checkArgs exprs [] expr >> return VVoid

  EApp _ (Ident "readInt") exprs ->
    checkArgs exprs [] expr >> return IInt

  EApp _ (Ident "readString") exprs ->
    checkArgs exprs [] expr >> return SString

  EApp pos f exprs -> do
    (fType, fArgs) <- lookupFunctionData f pos
    checkArgs exprs fArgs expr
    return fType

  EString _ _ -> return SString

  Neg pos negexpr -> do
    exprType <- getExprType negexpr
    checkType exprType [IInt] pos negexpr
    return IInt

  Not pos negexpr -> do
    exprType <- getExprType negexpr
    checkType exprType [BBool] pos negexpr
    return BBool

  EMul pos expr1 _ expr2 -> 
    checkIfBothSatisfyType [IInt] expr1 expr2 pos

  EAdd pos expr1 (Plus _) expr2 -> 
    checkIfBothSatisfyType [IInt, SString] expr1 expr2 pos


  EAdd pos expr1 (Minus _) expr2 -> 
    checkIfBothSatisfyType [IInt] expr1 expr2 pos

  ERel pos expr1 (EQU _) expr2 -> 
    checkIfBothSatisfyType comparableTypes expr1 expr2 pos

  ERel pos expr1 (NE _) expr2 -> 
    checkIfBothSatisfyType comparableTypes expr1 expr2 pos

  ERel pos expr1 _ expr2 -> 
    checkIfBothSatisfyType [SString, IInt] expr1 expr2 pos

  EAnd pos expr1 expr2 ->
    checkIfBothSatisfyType [BBool] expr1 expr2 pos

  EOr pos expr1 expr2 ->
    checkIfBothSatisfyType [BBool] expr1 expr2 pos

  where
    checkArgs :: [Expression] -> ArgsData -> Expression -> Frontend ()
    checkArgs [] [] _ = return ()

    checkArgs exprs [] (EApp pos x a) =
      throwError $ (extractLineColumn pos) ++ 
        (printTree (EApp pos x a)) ++ " wrong number of arguments"

    checkArgs [] args (EApp pos x a) = 
      throwError $ (extractLineColumn pos) ++ 
        (printTree (EApp pos x a)) ++ " wrong number of arguments"

    checkArgs (expr:exprsT) (argType:argsT) (EApp pos x a) = do
      exprType <- getExprType expr
      checkType exprType [argType] pos (EApp pos x a)
      checkArgs exprsT argsT (EApp pos x a)

    checkIfBothSatisfyType :: ExpectedTypes -> Expression -> Expression -> 
          (Maybe (Int, Int)) -> Frontend TType
    checkIfBothSatisfyType types expr1 expr2 pos = do
      expr1Type <- getExprType expr1
      checkType expr1Type types pos expr1
      expr2Type <- getExprType expr2
      checkType expr2Type [expr1Type] pos expr2
      return expr1Type

    checkType :: TType -> ExpectedTypes -> (Maybe (Int, Int))-> Expression -> Frontend ()
    checkType t types pos expr =
      if elem t types
        then return ()
        else throwError $ (extractLineColumn pos) ++ (printTree expr) ++ " wrong type"
