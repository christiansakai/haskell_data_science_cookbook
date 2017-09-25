#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package aeson
-}

{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import Control.Applicative
import qualified Data.ByteString.Lazy as B

data Mathematician =
  Mathematician {
    name :: String
  , nationality :: String
  , born :: Int
  , died :: Maybe Int
  } 

instance FromJSON Mathematician where
  parseJSON (Object v) = Mathematician
                     <$> (v .: "name")
                     <*> (v .: "nationality")
                     <*> (v .: "born")
                     <*> (v .:? "died")

main :: IO ()
main = do
  input <- B.readFile "input.json"
  let mm :: Maybe Mathematician
      mm = decode input

  case mm of
    Nothing -> print "error parsing JSON"
    Just m -> (putStrLn . greet) m

greet :: Mathematician -> String
greet m = (show . name) m
       ++ " was born in the year "
       ++ (show . born) m


