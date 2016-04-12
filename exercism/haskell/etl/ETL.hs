module ETL (transform) where

import Data.Map (Map, foldlWithKey', empty, insert)
import Data.List (foldl')
import Data.Char (toLower)

transform :: Map Int [String] -> Map String Int
transform raw = foldlWithKey' dataTransform empty raw
  where
    dataTransform output score letters = foldl' (dataInsert score) output letters
    dataInsert score output letter = insert (map toLower letter) score output
