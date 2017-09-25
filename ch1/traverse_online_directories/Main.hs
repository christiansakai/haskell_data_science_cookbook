#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package hxt
   --package HandsomeSoup
-}

import Network.HTTP
  ( Request ( Request )
  , HeaderName 
    ( HdrContentType
    , HdrContentLength
    )
  , RequestMethod (POST )
  , rqMethod
  , rqHeaders
  , rqBody
  , rqURI
  , mkHeader
  , simpleHTTP
  , getResponseBody
  )
import Network.URI (parseURI)
import Data.Maybe (fromJust)
import Text.XML.HXT.Core
  ( readString
  , withParseHTML
  , yes
  , withWarnings
  , no
  , runX
  , (>>>)
  , (//>)
  )
import Text.HandsomeSoup (css)

type SearchResult = 
  Either SearchResultErr [String]

data SearchResultErr = 
    NoResultsErr
  | TooManyResultsErr
  | UnknownErr
  deriving (Show, Eq)

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

getDoc query = do
  streamResult <- simpleHTTP $ myRequest query
  body <- getResponseBody streamResult
  return $ readString [withParseHTML yes, withWarnings no] body

-- scanDoc doc = do
--   errMsg 



  
