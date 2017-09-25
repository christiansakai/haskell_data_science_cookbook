import System.IO (readFile)
import System.Environment (getArgs)
import System.Directory (doesFileExist)

main :: IO ()
main = do
  args <- getArgs
  let filename :: String
      filename = 
        case args of
          (a:_) -> a
          _     -> "input.txt"

  fileExists <- doesFileExist filename
  input <- if fileExists then readFile filename else return ""
  print $ countWords input

countWords :: String -> [Int]
countWords string = map (length . words) $ lines string

