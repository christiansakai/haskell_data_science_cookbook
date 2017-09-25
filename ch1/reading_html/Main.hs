#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package hxt
   --package split
-}

import System.IO (readFile)
import Text.XML.HXT.Core
import Data.List.Split (chunksOf)

main :: IO ()
main = do
  input <- readFile "input.html"
  texts <- runX $ readString 
            [withParseHTML yes, withWarnings no] input
        //> hasName "th"
        //> getText

  let rows = chunksOf 3 texts
  print $ (findBiggest . tail) rows

findBiggest :: [[String]] -> [String]
findBiggest [] = []
findBiggest items = foldl1 compareCapacity items
  where compareCapacity acc el = if getCapacity el > getCapacity acc
                                    then el
                                    else acc
        getCapacity [course, time, capacity] = read capacity :: Int
        getCapacity _                        = -1


