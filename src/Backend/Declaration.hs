module Backend.Declaration where

import Backend.Statement
import Backend.Utils
import Grammar.AbsLatte
import Grammar.PrintLatte
import Control.Monad.Reader
import Control.Monad.State
import qualified Data.Map as M

genDecl :: [FuncWithData] -> Backend ()
genDecl fData = do
  addLine ".text\n"
  strConsts <- asks stringConstants
  genConsts $ M.toList strConsts
  addLine ".global main\n"
  genDeclAux fData

genConsts :: [(String, String)] -> Backend ()
genConsts [] = return ()
genConsts ((constVal, constName):constT) = do
  let constVal' = (take (length constVal - 1) constVal) ++ "\\0\""
  addLine $ constName ++ ": .ascii " ++ constVal'
  genConsts constT

genDeclAux :: [FuncWithData] -> Backend ()
genDeclAux [] = addLine "\n"
genDeclAux ((FnDef _ fType fIdent _ (Block _ stmts), varsCounter, argToAddress):decls) = do
  modify $ \store -> store { curLoc = 0 }
  let stmts' = case fType of
        Void _ -> stmts ++ [VRet Nothing]
        _ -> stmts
  addLine $ (printTree fIdent) ++ ":"
  local (nextPrefix . \env -> env { variables = argToAddress }) $ do
    addLines ["pushl %ebp", "movl %esp, %ebp", 
              "subl $" ++ (show $ 4 *varsCounter) ++ ", %esp"]
    genStmts stmts'
  genDeclAux decls