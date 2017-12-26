#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package mongoDB
   --package split
   --package uri
-}

{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

import Database.MongoDB
import Text.URI
import Data.Maybe
import qualified Data.Text as T
import Data.List.Split
import Control.Monad.IO.Class

mongoURI :: String
mongoURI = "mongodb://user:pass@ds12345.mongolab.com:53788/mydb"

uri :: URI
uri = fromJust . parseURI $ mongoURI

getUserPass :: [String]
getUserPass = splitOn ":" . fromJust . uriUserInfo $ uri

getUser :: String
getUser = head getUserPass 

getPass :: String
getPass = last getUserPass

getHost :: String
getHost = fromJust $ uriRegName uri

getPort :: String
getPort = case uriPort uri of
            Just port -> show port
            Nothing   -> last . words . show $ defaultPort

getDb :: T.Text
getDb = T.pack . tail . uriPath $ uri

getData = rest =<< find (select [] "people") { sort = [] }

run = do
  auth (T.pack getUser) (T.pack getPass) 
  getData

main :: IO ()
main = do
  let hostport = getHost ++ ":" ++ getPort
  pipe <- connect (readHostPort hostport)
  e <- access pipe master getDb run
  close pipe
  print e

