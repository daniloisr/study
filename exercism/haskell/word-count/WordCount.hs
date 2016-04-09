module WordCount (wordCount) where

import Data.Map (Map, insertWith, empty)
import Data.List (foldl')
import Data.Char (isAlphaNum, toLower)
import Data.List.Split (wordsBy)

wordCount :: String -> Map String Int
wordCount = foldl' increment empty . chunks
  where
    increment m w = insertWith (+) w 1 m
    chunks = wordsBy (not . isAlphaNum) . map toLower
