#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package mongoDB
-}

{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

import Database.MongoDB 
  ( connect
  , host
  , access
  , master
  , close
  , rest
  , find
  , select
  , sort
  , Action
  )
import Data.Bson (Document)

main :: IO ()
main = do
  let dbName = "test"
      hostName = "127.0.0.1"

  pipe <- connect (host hostName)
  document <- access pipe master dbName run

  close pipe
  print document

run :: Action IO [Document]
run = 
  rest =<< find (select [] "people") { sort = [] }
 
