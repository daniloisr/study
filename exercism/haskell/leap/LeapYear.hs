module LeapYear where

isLeapYear :: Int -> Bool
isLeapYear n =
  (n `mod` 4) == 0 &&
  (
    (n `mod` 100) /= 0 ||
    (n `mod` 400) == 0
  )
