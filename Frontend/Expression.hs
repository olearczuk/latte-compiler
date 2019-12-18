module Frontend.Expression where

import Frontend.Utils
import Grammar.AbsLatte
import Grammar.PrintLatte
import Control.Monad.Except

getExprType :: Expression -> Frontend TType
getExprType expr = case expr of
  EVar pos x -> lookupVariableType x pos

  ELitInt _ _ -> return iInt

  ELitTrue _ -> return bBool

  ELitFalse _ -> return bBool

  EApp _ (Ident "printInt") exprs ->
    checkArgs exprs [(iInt, Ident "x")] expr >> return vVoid

  EApp _ (Ident "printString") exprs ->
    checkArgs exprs [(sString, Ident "x")] expr >> return vVoid

  EApp _ (Ident "error") exprs ->
    checkArgs exprs [] expr >> return vVoid

  EApp _ (Ident "readInt") exprs ->
    checkArgs exprs [] expr >> return iInt

  EApp _ (Ident "readString") exprs ->
    checkArgs exprs [] expr >> return sString

  EApp pos f exprs -> do
    (fType, fArgs) <- lookupFunctionData f pos
    checkArgs exprs fArgs expr
    return fType

  EString _ _ -> return sString

  Neg pos negexpr -> do
    exprType <- getExprType negexpr
    checkType exprType [iInt] pos negexpr
    return iInt

  Not pos negexpr -> do
    exprType <- getExprType negexpr
    checkType exprType [bBool] pos negexpr
    return bBool

  EMul pos expr1 _ expr2 -> 
    checkIfBothSatisfyType [iInt] expr1 expr2 pos

  EAdd pos expr1 (Plus _) expr2 -> 
    checkIfBothSatisfyType [iInt, sString] expr1 expr2 pos


  EAdd pos expr1 (Minus _) expr2 -> 
    checkIfBothSatisfyType [iInt] expr1 expr2 pos

  ERel pos expr1 (EQU _) expr2 -> 
    checkIfBothSatisfyType comparableTypes expr1 expr2 pos >>
    return bBool

  ERel pos expr1 (NE _) expr2 -> 
    checkIfBothSatisfyType comparableTypes expr1 expr2 pos >>
    return bBool

  ERel pos expr1 _ expr2 -> 
    checkIfBothSatisfyType [sString, iInt] expr1 expr2 pos >>
    return bBool

  EAnd pos expr1 expr2 ->
    checkIfBothSatisfyType [bBool] expr1 expr2 pos

  EOr pos expr1 expr2 ->
    checkIfBothSatisfyType [bBool] expr1 expr2 pos

  where
    checkArgs :: [Expression] -> ArgsData -> Expression -> Frontend ()
    checkArgs [] [] _ = return ()

    checkArgs exprs [] (EApp pos x a) =
      throwError $ (extractLineColumn pos) ++ 
        (printTree (EApp pos x a)) ++ " wrong number of arguments"

    checkArgs [] args (EApp pos x a) = 
      throwError $ (extractLineColumn pos) ++ 
        (printTree (EApp pos x a)) ++ " wrong number of arguments"

    checkArgs (expr:exprsT) ((argType, _):argsT) (EApp pos x a) = do
      exprType <- getExprType expr
      checkType exprType [argType] pos (EApp pos x a)
      checkArgs exprsT argsT (EApp pos x a)

    checkIfBothSatisfyType :: ExpectedTypes -> Expression -> Expression -> 
          InstrPos -> Frontend TType
    checkIfBothSatisfyType types expr1 expr2 pos = do
      expr1Type <- getExprType expr1
      checkType expr1Type types pos expr1
      expr2Type <- getExprType expr2
      checkType expr2Type [expr1Type] pos expr2
      return expr1Type
