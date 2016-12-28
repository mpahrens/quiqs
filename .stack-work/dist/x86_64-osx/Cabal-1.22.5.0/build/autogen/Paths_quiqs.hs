module Paths_quiqs (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,0,2] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/matt/quiqs/.stack-work/install/x86_64-osx/lts-6.27/7.10.3/bin"
libdir     = "/Users/matt/quiqs/.stack-work/install/x86_64-osx/lts-6.27/7.10.3/lib/x86_64-osx-ghc-7.10.3/quiqs-0.0.2-Dvi6RpKYBdRHLprIFkUIK4"
datadir    = "/Users/matt/quiqs/.stack-work/install/x86_64-osx/lts-6.27/7.10.3/share/x86_64-osx-ghc-7.10.3/quiqs-0.0.2"
libexecdir = "/Users/matt/quiqs/.stack-work/install/x86_64-osx/lts-6.27/7.10.3/libexec"
sysconfdir = "/Users/matt/quiqs/.stack-work/install/x86_64-osx/lts-6.27/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "quiqs_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "quiqs_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "quiqs_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "quiqs_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "quiqs_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
