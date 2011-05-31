module Paths_reversi (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,1], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/Users/guiocavalcanti/.cabal/bin"
libdir     = "/Users/guiocavalcanti/.cabal/lib/reversi-0.1/ghc-7.0.3"
datadir    = "/Users/guiocavalcanti/.cabal/share/reversi-0.1"
libexecdir = "/Users/guiocavalcanti/.cabal/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "reversi_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "reversi_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "reversi_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "reversi_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
