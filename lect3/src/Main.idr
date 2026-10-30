module Main

import Data.String

printRange : Integer -> Integer -> IO ()
printRange a b = do
  printLn a
  if a == b
    then pure ()
    else if a < b
      then printRange (a + 1) b
      else printRange (a - 1) b

main : IO ()
main = do
  s1 <- getLine
  s2 <- getLine
  case (parseInteger (trim s1), parseInteger (trim s2)) of
    (Just a, Just b) => printRange a b
    _                => putStrLn "Ошибка ввода"