#!/usr/local/bin/stack
{- stack 
   exec runhaskell
   --resolver lts-9.3 
   --install-ghc 
   --package MissingH
-}

import Data.String.Utils (replace)

main :: IO ()
main = do
  let quote = "Deep Blue plays fery good chess-so what?\
               \ Does that tell you something about how we play chess?\
               \ No. Does it tell you about how Kasparov envisions,\
               \ understands a chessboard? (Douglas Hofstadter)"
  putStrLn . removePunctuation' . replaceSpecialSymbols' $ quote

punctuations :: [Char]
punctuations = [ '!', '"', '#', '$', '%'
               , '(', ')', '.', ',', '?'
               ]

removePunctuation :: String -> String
removePunctuation = 
  filter (`notElem` punctuations)

specialSymbols :: [Char]
specialSymbols = ['/', '-']

replaceSpecialSymbols :: String -> String
replaceSpecialSymbols = 
  map (\c -> if c `elem` specialSymbols then ' ' else c)


punctuations' :: [String]
punctuations' = fmap (\c -> [c]) punctuations

removePunctuation' :: String -> String
removePunctuation' = 
  foldr (.) id $ fmap (flip replace "") punctuations'

specialSymbols' :: [String]
specialSymbols' = fmap (\c -> [c]) specialSymbols

replaceSpecialSymbols' :: String -> String
replaceSpecialSymbols' =
  foldr (.) id $ fmap (flip replace " ") specialSymbols'
