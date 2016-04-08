module Hamming (distance) where

distance :: String -> String -> Int
distance = (sum .) . zipWith ((fromEnum .) . (/=))
