module DNA (count, nucleotideCounts) where

import Data.Map.Strict (fromList, Map)

count :: Char -> String -> Int
count nucleotide =
  length . filter (validNucleotide ==) . map validBase
  where
    validNucleotide = validBase nucleotide

nucleotideCounts :: String -> Map Char Int
nucleotideCounts strand = fromList $ map (\n -> (n, count n strand)) "ATCG"


validBase :: Char -> Char
validBase base
  | base `elem` "ACGT" = base
  | otherwise = error ("invalid nucleotide " ++ show base)
