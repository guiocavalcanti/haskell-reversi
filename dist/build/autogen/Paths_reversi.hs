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

bindir     = "/usr/local/bin"
libdir     = "/usr/local/lib/reversi-0.1/ghc-6.12.3"
datadir    = "/usr/local/share/reversi-0.1"
libexecdir = "/usr/local/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "reversi_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "reversi_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "reversi_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "reversi_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
