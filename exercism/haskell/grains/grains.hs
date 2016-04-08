module Grains where

square :: Integer -> Integer
square i = 2 ^ (i - 1)

total :: Integer
total = foldr ((+) . square) 0 [1..64]
