module Backend.Declaration where

import Backend.Statement
import Backend.Utils
import Grammar.AbsLatte
import Grammar.PrintLatte
import Control.Monad.Reader

genDecl :: [FuncWithData] -> Backend ()
genDecl [] = addLine "\n"
genDecl ((FnDef _ fType fIdent _ (Block _ stmts), varsCounter, argToAddress):decls) = do
  let stmts' = case fType of
        Void _ -> stmts ++ [VRet Nothing]
        _ -> stmts
  addLine $ (printTree fIdent) ++ ":"
  local (nextPrefix . \env -> env { variables = argToAddress }) $ do
    addLines ["pushl %ebp", "movl %esp, %ebp", 
              "subl $" ++ (show $ 4 *varsCounter) ++ ", %esp"]
    genStmts stmts'
  genDecl decls