module Bob where

import Data.Char (isUpper, isAlpha, isSpace)

responseFor :: String -> String
responseFor s
  | isEmpty s = "Fine. Be that way!"
  | isShout s = "Whoa, chill out!"
  | isQuestion s = "Sure."
  | otherwise = "Whatever."
  where
    isEmpty = all isSpace
    isShout s = allUpper && anyAlpha
      where
        alphas = filter isAlpha s
        anyAlpha = length alphas > 0
        allUpper = all isUpper alphas
    isQuestion = (==) '?' . last
