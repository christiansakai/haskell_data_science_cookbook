#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package hxt
   --package HandsomeSoup
-}

import Network.HTTP
import Network.URI (parseURI)
import Text.XML.HXT.Core
import Text.HandsomeSoup
import Data.Maybe (fromJust)

myRequestURL :: String
myRequestURL = "http://www.virginia.edu/cgi-local/ldapweb"

myRequest :: String -> Request String
myRequest query = Request {
    rqURI = fromJust $ parseURI myRequestURL
  , rqMethod = POST
  , rqHeaders = [ mkHeader HdrContentType "text/html"
                , mkHeader HdrContentLength $ show $ length body
                ]
  , rqBody = body
  }
    where body  = "whitepages=" ++ query

main :: IO ()
main = do
  response <- simpleHTTP $ myRequest "poon"
  html <- getResponseBody response

  let doc = readString [ withParseHTML yes, withWarnings no] html

  rows <- runX $ doc >>> css "td" //> getText
  print rows


