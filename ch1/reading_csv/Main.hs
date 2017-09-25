#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package csv
-}

import System.IO (readFile)
import Text.CSV (parseCSV, CSV, Record)

main :: IO ()
main = do
  let fileName = "input.csv"
  input <- readFile fileName

  let csv = parseCSV fileName input
      handleError csv = putStrLn "error parsing"
      doWork csv = (print . findOldest . tail) csv

  either handleError doWork csv

findOldest :: [Record] -> Record
findOldest [] = [] 
findOldest xs = foldl1 checkAge xs
  where checkAge acc el = if getAge acc > getAge el
                             then acc
                             else el
        getAge :: Record -> Int
        getAge [name, age] = read age
        getAge _           = 0

