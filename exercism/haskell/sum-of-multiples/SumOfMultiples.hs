module SumOfMultiples (sumOfMultiples, sumOfMultiplesDefault) where

sumOfMultiplesDefault :: Int -> Int
sumOfMultiplesDefault n = sumOfMultiples [3, 5] n

sumOfMultiples :: [Int] -> Int -> Int
sumOfMultiples xs x
  | x == 1 = 0
  | any (\x -> n `mod` x == 0) xs = n + (sumOfMultiples xs n)
  | otherwise = sumOfMultiples xs n
  where n = x - 1
