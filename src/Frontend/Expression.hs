module Frontend.Expression where

import Frontend.Utils
import Grammar.AbsLatte
import Grammar.PrintLatte
import Control.Monad.Except
import Control.Monad.State
import Common.Utils

getExprType :: Expression -> Frontend TType
getExprType expr = case expr of
  -- first check x, then self.x -- DONE
  ELValue _ (Var pos x) -> lookupVariableType x pos

  ELValue _ (ObjField pos lval ident) -> do
    exprType <- getExprType $ ELValue Nothing lval
    checkType exprType [cClass] pos lval
    getClassFieldType exprType ident expr pos -- (ObjField pos lval ident)

  ELitInt _ _ -> return iInt

  ELitTrue _ -> return bBool

  ELitFalse _ -> return bBool

  EApp _ (Ident "printInt") exprs ->
    checkArgs exprs [(Arg Nothing iInt (Ident "x"))] expr >> return vVoid

  EApp _ (Ident "printString") exprs ->
    checkArgs exprs [(Arg Nothing sString (Ident "x"))] expr >> return vVoid

  EApp _ (Ident "error") exprs ->
    checkArgs exprs [] expr >> return vVoid

  EApp _ (Ident "readInt") exprs ->
    checkArgs exprs [] expr >> return iInt

  EApp _ (Ident "readString") exprs ->
    checkArgs exprs [] expr >> return sString

-- TODO - first check self.f, then f --- DONE
  EApp pos f exprs -> do
    fData <- lookupMethodFunctionData f pos
    case fData of
      Just (fType, fArgs) -> checkArgs exprs fArgs expr >> return fType
      Nothing -> 
        let lval = (Var pos (Ident "self")) in
        getExprType $ EMethod pos lval f exprs

  EString _ s -> addStrConstant s >> return sString

  ENewObj _ (Class pos ident) ->
    getClassInfo ident pos >> return (Class pos ident)
  ENewObj pos t ->
    throwError $ (extractLineColumn t pos) ++ " not a class type"

  ENull _ (Class pos ident) ->
    getClassInfo ident pos >> return (Class pos ident)
  ENull pos t ->
    throwError $ (extractLineColumn t pos) ++ " not a class type"

  -- EMethod a (LValue a) Ident [Expr a] -- DONE
  EMethod pos lval f exprs -> do
    exprType <- getExprType $ ELValue Nothing lval
    checkType exprType [cClass] pos lval
    (_, fType, args) <- getClassMethodData exprType f $ getLValPos lval
    checkArgs (ELValue Nothing lval:exprs) args expr
    return fType

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
    checkArgs :: [Expression] -> [Arg InstrPos] -> Expression -> Frontend ()
    checkArgs [] [] _ = return ()

    checkArgs exprs [] fExpr =
      throwError $ (extractLineColumn fExpr $ getExprPos fExpr) ++ " wrong number of arguments"

    checkArgs [] args fExpr = 
      throwError $ (extractLineColumn fExpr $ getExprPos fExpr) ++ " wrong number of arguments"

    checkArgs (expr:exprsT) ((Arg _ argType _):argsT) fExpr = do
      exprType <- getExprType expr
      let exprPos = getExprPos expr
      checkIfAssignable argType exprType exprPos expr
      checkArgs exprsT argsT fExpr

    checkIfBothSatisfyType :: ExpectedTypes -> Expression -> Expression -> 
          InstrPos -> Frontend TType
    checkIfBothSatisfyType types expr1 expr2 pos = do
      expr1Type <- getExprType expr1
      let expr1Pos = getExprPos expr1
      checkType expr1Type types expr1Pos expr1

      expr2Type <- getExprType expr2
      let expr2Pos = getExprPos expr2
      checkIfExactSameType expr2Type expr1Type expr2Pos expr2

      return expr1Type

getExprPos :: Expression -> InstrPos
getExprPos expr = case expr of
  ELValue _ lval -> getLValPos lval
  ELitInt pos _ -> pos
  ELitTrue pos -> pos
  ELitFalse pos -> pos
  EApp pos _ _ -> pos
  EString pos _ -> pos
  ENewObj pos _ -> pos
  ENull pos _ -> pos
  EMethod pos _ _ _ -> pos
  Neg pos _ -> pos
  Not pos _ -> pos
  EMul pos _ _ _ -> pos
  EAdd pos _ _ _ -> pos
  ERel pos _ _ _ -> pos
  EAnd pos _ _ -> pos
  EOr pos _ _ -> pos

getLValPos :: LLValue -> InstrPos
getLValPos (Var pos _) = pos
getLValPos (ObjField pos _ _) = pos