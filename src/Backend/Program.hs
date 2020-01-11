module Backend.Program where

import Grammar.AbsLatte
import Backend.Utils
import Backend.Expression
import Backend.Declaration
import Backend.Statement
import Control.Monad.State
import Control.Monad.Reader
import Control.Monad.Writer
import qualified Data.Map as M
import qualified Data.DList as DL

genProgram :: ([FuncWithData], FunctionsRetTypes, StringConstants, ClassesInfo) -> String
genProgram (funcWithData, fRetTypes, strConsts, classes_) =
  let res = execWriter (runReaderT (evalStateT (genDecl funcWithData) initStore) 
                        $ initEnv fRetTypes strConsts classes_) in 
  combineLines res

combineLines :: DL.DList String -> String
combineLines dlist = DL.toList $ 
  foldl (\acc el -> DL.append acc $ DL.fromList el) (DL.fromList "") dlist