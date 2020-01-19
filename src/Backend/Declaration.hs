module Backend.Declaration where

import Backend.Statement
import Backend.Utils
import Grammar.AbsLatte
import Grammar.PrintLatte
import Control.Monad.Reader
import Control.Monad.State
import qualified Data.Map as M
import Data.Maybe
import Data.Tuple
import Common.Utils

genDecl :: [FuncWithData] -> [MethodWithData] -> Backend ()
genDecl fData mData= do
  addLine ".text\n"
  strConsts <- asks stringConstants
  genConsts $ M.toList strConsts
  genVtables
  addLine ".global main\n"
  genClasses
  genDeclFunc fData
  genDeclMeth mData

genConsts :: [(String, String)] -> Backend ()
genConsts [] = return ()
genConsts ((constVal, constName):constT) = do
  let constVal' = (take (length constVal - 1) constVal) ++ "\\0\""
  addLine $ constName ++ ": .ascii " ++ constVal'
  genConsts constT

genVtables :: Backend ()
genVtables = do
  classes_ <- asks classes
  mapM_ genVtableForClass $ M.toList classes_
  where
    genVtableForClass :: (Ident, ClassInfo) -> Backend ()
    genVtableForClass (classId, classInfo) = do
      let methods_ = methods classInfo
          vtableIndex_ = M.fromList (map swap 
            (M.toList $ vtableIndex classInfo))
      line <- genVtableForClassAux vtableIndex_ methods_ 0
      addLine $ (printTree classId) ++ ": .int " ++ line
    genVtableForClassAux :: (M.Map Int Ident) -> 
      M.Map Ident MethodData -> Int -> Backend String
    genVtableForClassAux vtableIndex_ methods_ counter =
      if counter >= M.size vtableIndex_
        then return ""
        else do
          let funcId = fromJust $ M.lookup counter vtableIndex_
          let (classId, _, _) = fromJust $ M.lookup funcId methods_
          tail <- genVtableForClassAux vtableIndex_ methods_ (counter + 1)
          if tail == ""
            then
              return $ "__" ++ (printTree classId) ++ "_" ++ (printTree funcId)
            else 
              return $ "__" ++ (printTree classId) ++ "_" ++ (printTree funcId) ++ ", " ++ tail

genDeclFunc :: [FuncWithData] -> Backend ()
genDeclFunc [] = addLine ""
genDeclFunc ((FnDef _ fType fIdent _ (Block _ stmts), varsCounter, varToAddress):decls) = do
  modify $ \store -> store { curLoc = 0 }
  let stmts' = case fType of
        Void _ -> stmts ++ [VRet Nothing]
        _ -> stmts
  addLine $ (printTree fIdent) ++ ":"
  local (nextPrefix . \env -> env { variables = varToAddress }) $ do
    addLines ["pushl %ebp", "movl %esp, %ebp", 
              "subl $" ++ (show $ 4 *varsCounter) ++ ", %esp"]
    genStmts stmts'
  genDeclFunc decls

genDeclMeth :: [MethodWithData] -> Backend ()
genDeclMeth [] = addLine "\n"
genDeclMeth ((classId, FnDef _ fType fIdent _ (Block _ stmts), varsCounter, varToAddress):decls) = do
  modify $ \store -> store { curLoc = 0 }
  let stmts' = case fType of
        Void _ -> stmts ++ [VRet Nothing]
        _ -> stmts
  addLine $ "__" ++ (printTree classId) ++ "_" ++ (printTree fIdent) ++ ":"
  local (nextPrefix . \env -> env { variables = varToAddress }) $ do
    addLines ["pushl %ebp", "movl %esp, %ebp", 
              "subl $" ++ (show $ 4 *varsCounter) ++ ", %esp"]
    genStmts stmts'
  genDeclMeth decls

genClasses :: Backend ()
genClasses = do
  classes_ <- asks classes
  genClassesAux $ M.toList classes_
  where 
    genClassesAux :: [(Ident, ClassInfo)] -> Backend ()
    genClassesAux [] = return ()
    genClassesAux ((cIdent, classInfo):tail) = do
      let fields_ = fields classInfo
      addLine $ "__constructor_" ++ (printTree cIdent) ++ ":"
      local nextPrefix $ do
        addLines ["pushl %ebp", "movl %esp, %ebp", "pushl %edi"]
        addLine $ "pushl $" ++ (show $ 4 + 4 * M.size fields_)
        addLines  ["call allocateMemory",  "addl $4, %esp"]
        addLine "movl %eax, %edi"
        addLine $ "movl $" ++ (printTree cIdent) ++ ", (%edi)"
        mapM_ setAttr $ M.toList fields_
        addLines ["movl %edi, %eax", "popl %edi", "leave", "ret"]
      genClassesAux tail

    setAttr :: (Ident, (VarPos, TType)) -> Backend ()
    setAttr (_, (loc, xType)) = do
      str <- setDefaultValue xType
      addLine $ str ++ (show loc) ++ "(%edi)"