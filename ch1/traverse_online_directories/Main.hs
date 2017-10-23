#!/usr/local/bin/stack
{- stack 
   exec runhaskell
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
  , getText
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

scanDoc doc = do
  errMsgs <- runX $ doc >>> css "h3" //> getText 
  
  case errMsgs of
    [] -> do
      text <- runX $ doc >>> css "td" //> getText
      return $ Right text

    "Error: Sizelimit exceeded" : _ ->
      return $ Left TooManyResultsErr

    "Too many matching entries were found" : _ ->
      return $ Left TooManyResultsErr

    "No matching entries were found": _ ->
      return $ Left NoResultsErr

    _ ->
      return $ Left UnknownErr

main :: IO ()
main = main' "a"

main' :: String -> IO ()
main' query = do
  print query
  doc <- getDoc query
  searchResult <- scanDoc doc
  print searchResult
  
  case searchResult of
    Left TooManyResultsErr ->
      main' (nextDeepQuery query)

    _ ->
      if (nextQuery query) >= endQuery
         then print "done!"
         else main' (nextQuery query)

nextDeepQuery query = query ++ "a"

nextQuery "z" = endQuery
nextQuery query = 
  if last query == 'z'
     then nextQuery $ init query
     else init query ++ [succ $ last query]
endQuery = [succ 'z']

