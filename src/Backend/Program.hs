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
import Common.Utils

genProgram :: FrontendResult -> String
genProgram frontendResult =
  let fWithData = funcWithData frontendResult
      fRetTypes = funcRetTypes frontendResult
      sConsts = strConsts frontendResult
      clInfo = classesInfo frontendResult
      mWithData = methodsWithData frontendResult in
  let res = execWriter (runReaderT (evalStateT (genDecl fWithData mWithData) initStore) 
                        $ initEnv fRetTypes sConsts clInfo) in 
  combineLines res

combineLines :: DL.DList String -> String
combineLines dlist = DL.toList $ 
  foldl (\acc el -> DL.append acc $ DL.fromList el) (DL.fromList "") dlist