module School where

import Data.IntMap (IntMap, insertWith, findWithDefault, toAscList)
import qualified Data.IntMap as M (empty)
import Data.List (insert)

type School = IntMap [String]

empty :: School
empty = M.empty

add :: Int -> String -> School -> School
add i name = insertWith (insert . head) i [name]

sorted :: School -> [(Int, [String])]
sorted = toAscList

grade :: Int -> School -> [String]
grade = findWithDefault []
