module Frontend.Program where

import Grammar.AbsLatte
import Frontend.Utils
import Frontend.Declaration
import Control.Monad.Except
import Control.Monad.Reader
import Control.Monad.State

checkProgram :: Program InstrPos -> Either String ([FuncWithData], FunctionsRetTypes, StringConstants, ClassesInfo)
checkProgram (Program _ decls) =
  runExcept $ runReaderT (evalStateT (checkDecls decls) initStore) initEnv 