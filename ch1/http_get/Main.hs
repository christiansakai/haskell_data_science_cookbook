#!/usr/local/bin/stack
{- stack 
   exec ghci
   --resolver lts-9.3 
   --install-ghc 
   --package hxt
   --package HandsomeSoup
-}

import System.IO (readFile)
import Text.XML.HXT.Core
import Text.HandsomeSoup (fromUrl, (!), css)

main :: IO ()
main = do
  let doc = fromUrl "http://en.wikipedia.org/wiki/Narwhal"

  links <- runX $ doc >>> css "#bodyContent a" ! "href"
  print links
