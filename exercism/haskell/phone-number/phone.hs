module Phone (areaCode, number, prettyPrint) where

import Data.Char(isNumber)

number :: String -> String
number rawNumber
  | numbersLenght == 10 = numbers
  | numbersLenght == 11 && first == '1' = number tailNumbers
  | otherwise = "0000000000"
  where
    numbers = filter isNumber rawNumber
    numbersLenght = length numbers
    first = head numbers
    tailNumbers = tail numbers

areaCode :: String -> String
areaCode = take 3 . number

prettyPrint :: String -> String
prettyPrint raw =
  "(" ++ (areaCode n) ++ ")" ++ " " ++ (take 3 $ drop 3 n) ++ "-" ++ (drop 6 n)
  where
    n = number raw