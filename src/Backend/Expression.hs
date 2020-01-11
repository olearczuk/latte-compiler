module Backend.Expression where

import Backend.Utils
import Grammar.AbsLatte
import Grammar.PrintLatte

genExpr :: Expression -> Backend TType
genExpr expr = case expr of
  ELValue _ (Var _ x) -> do
    (varPos, varType) <- getVarInfo x
    addLine $ "movl " ++ (show varPos) ++ "(%ebp), %eax"
    return varType

  ELValue _ (ObjField _ lval x) -> do
    Class _ classId <- genExpr $ ELValue Nothing lval
    (varPos, varType) <- getFieldLoc classId x
    addLine $ "movl " ++ (show varPos) ++ "(%eax), %eax"
    return varType

  ELitInt _ n -> do
    addLine $ "movl $" ++ (show n) ++ ", %eax"
    return iInt

  ELitTrue _ -> do
    addLine $ "movl $1, %eax" 
    return bBool

  ELitFalse _ -> do 
    addLine $ "movl $0, %eax" 
    return bBool

  EApp _ f exprs -> do
    pushArguments exprs
    addLine $ "call " ++ (printTree f)
    addLine $ "addl $" ++ (show (4 * (length exprs))) ++ ", %esp"
    getFunctionType f

  EString _ s -> do
    curConst <- getStrConst s
    addLine $ "movl $" ++ curConst ++ ", %eax"
    return sString

  ENewObj _ (Class _ id) -> do
    addLine $ "call __constructor_" ++ (printTree id)
    return (Class Nothing id)

  ENull _ t -> do
    addLine "movl $0, %eax"
    return t

  -- EMethod a (LValue a) Ident [Expr a]

  Neg _ negexpr -> do
    exprType <- genExpr negexpr
    addLine "imul $-1, %eax"
    return exprType
  
  Not _ negexpr -> do
    exprType <- genExpr negexpr
    addLines ["xorl $1, %eax"]
    return exprType

  EMul _ expr1 op expr2 -> do
    exprType <- genExpr expr2
    pushEax
    genExpr expr1
    popEcx
    case op of
      Times _ -> addLine "imul %ecx, %eax"
      Div _ -> addLines ["movl $0, %edx", "div %ecx, %eax"]
      Mod _ -> addLines ["movl $0, %edx", "div %ecx, %eax", "movl %edx, %eax"]
    return exprType

  EAdd _ expr1 op expr2 -> do
    exprType <- genExpr expr2
    pushEax
    genExpr expr1
    popEcx
    case op of
      Plus _ -> case exprType of
        Int _ -> addLine "addl %ecx, %eax"
        Str _ -> 
          addLines ["pushl %ecx", "pushl %eax", "call addStrings", 
                    "addl $8, %esp"]
      Minus _ -> addLine "subl %ecx, %eax"
    return exprType

  ERel _ expr1 rel expr2 -> do
    exprType <- genExpr expr2
    pushEax
    genExpr expr1
    popEcx

    curBlock <- curBlockCounter
    let curRel = "__rel_" ++ curBlock

    case exprType of
      Str _ -> do
        addLines ["pushl %ecx", "pushl %eax", "call compareStrings"]
        addLine "cmp $0, %eax"
      _ -> addLine "cmp %ecx, %eax"
    case rel of
      LTH _ -> addLine $ "jl " ++ curRel
      LE _ -> addLine $ "jle " ++ curRel
      GTH _ -> addLine $ "jg " ++ curRel
      GE _ -> addLine $ "jge " ++ curRel
      EQU _ -> addLine $ "je " ++ curRel
      NE _ -> addLine $ "jne " ++ curRel
    addLines ["movl $0, %eax", "jmp " ++ curRel ++ "_end",
              curRel ++ ": movl $1, %eax", curRel ++ "_end:"]
    return exprType

  EAnd _ expr1 expr2 -> do
    exprType <- genExpr expr1
    curBlock <- curBlockCounter
    let curAnd = "__and_" ++ curBlock
    addLines ["cmp $0, %eax", "je " ++ curAnd]
    pushEax
    genExpr expr2
    popEcx
    addLines ["andl %ecx, %eax", curAnd ++ ":"]
    return exprType

  EOr _ expr1 expr2 -> do
    exprType <- genExpr expr1
    curBlock <- curBlockCounter
    let curOr = "__or_" ++ curBlock
    addLines ["cmp $1, %eax", "je " ++ curOr]
    pushEax
    genExpr expr2
    popEcx
    addLines ["orl %ecx, %eax", curOr ++ ":"]
    return exprType

  where
    pushArguments :: [Expression] -> Backend ()
    pushArguments [] = return ()
    pushArguments (exprH:exprT) = do
      pushArguments exprT
      genExpr exprH
      pushEax
      return ()
