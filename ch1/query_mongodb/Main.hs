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
import Control.Monad.IO.Class

main :: IO ()
main = do
  let db = "test"
      hostName = "127.0.0.1"
  pipe <- connect . host $ hostName
  result <- access pipe master db run
  close pipe
  print result

run :: MonadIO m => Action m [Document]
run = rest =<< find (select [] "people") { sort = [] }
