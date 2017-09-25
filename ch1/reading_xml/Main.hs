#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package hxt
-}

import Text.XML.HXT.Core
import System.IO (readFile)

main :: IO ()
main = do
  input <- readFile "input.xml"
  dates <- runX $ readString [withValidate no] input
        //> hasName "date"
        //> getText
  print dates

