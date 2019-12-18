module Frontend.Program where

import Grammar.AbsLatte
import Frontend.Utils
import Frontend.Declaration
import Control.Monad.Except
import Control.Monad.Reader

checkProgram :: Program InstrPos -> Either String ()
checkProgram (Program _ decls) =
  runExcept $ runReaderT (checkDecls decls) initEnv