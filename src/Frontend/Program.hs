module Frontend.Program where

import Grammar.AbsLatte
import Frontend.Utils
import Frontend.Declaration
import Control.Monad.Except
import Control.Monad.Reader
import Control.Monad.State
import Common.Utils

checkProgram :: Program InstrPos -> Either String FrontendResult
checkProgram (Program _ decls) =
  runExcept $ runReaderT (evalStateT (checkDecls decls) initStore) initEnv 