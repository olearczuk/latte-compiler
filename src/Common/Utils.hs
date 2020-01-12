module Common.Utils where

import Grammar.AbsLatte
import qualified Data.Map as M

type InstrPos = Maybe (Int, Int)
type VarsCounter = Integer
type VarPos = Int
type TType = Type InstrPos
type IItem = Item InstrPos
type VarToAddress = (M.Map Ident (VarPos, TType))
type EExtends = Extends InstrPos

type MethodData = (Ident, TType, [Arg InstrPos])
type FuncWithData = (TopDef InstrPos, VarsCounter, VarToAddress)
type MethodWithData = (Ident, TopDef InstrPos, VarsCounter, VarToAddress)
type FunctionsRetTypes = M.Map Ident TType
type Expression = Expr InstrPos
type Statement = Stmt InstrPos
type StringConstants = M.Map String String
type ClassesInfo = M.Map Ident ClassInfo

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

data ClassInfo = ClassInfo {
  fields :: VarToAddress,
  extends :: EExtends,
  methods :: M.Map Ident MethodData,
  vtableIndex :: M.Map Ident Int
}

initClassInfo :: EExtends -> ClassInfo
initClassInfo extends_ = ClassInfo {
  fields = M.empty,
  extends = extends_,
  methods = M.empty,
  vtableIndex = M.empty
}

data FrontendResult = FrontendResult { 
  funcWithData :: [FuncWithData],
  funcRetTypes :: FunctionsRetTypes,
  strConsts :: StringConstants,
  classesInfo :: ClassesInfo,
  methodsWithData :: [MethodWithData]
}


initFrontendResult :: FunctionsRetTypes -> StringConstants -> ClassesInfo -> FrontendResult
initFrontendResult fRetTypes sConsts clInfo = FrontendResult {
  funcWithData = [],
  funcRetTypes = fRetTypes,
  strConsts = sConsts,
  classesInfo = clInfo,
  methodsWithData = []
}
