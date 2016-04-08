module Anagram (anagramsFor) where

import Data.List (sort)
import Data.Char (toLower)

anagramsFor :: String -> [String] -> [String]
anagramsFor w ws =
  filter isAnagram ws
  where
    isAnagram word = lw /= sToLower word && sortedW == sort (sToLower word)
    sToLower = map toLower
    sortedW = sort lw
    lw = map toLower w
