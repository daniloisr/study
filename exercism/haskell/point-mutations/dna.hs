module DNA (hammingDistance) where

import Data.List (foldl')

hammingDistance :: String -> String -> Int
hammingDistance a b =
  foldl' (+) 0 diffs
  where
    zipped = zip a b
    diff (a, b)
      | a /= b = 1
      | otherwise = 0
    diffs = map diff zipped
