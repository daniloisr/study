module LinkedList where

data List a = Empty | Item a (List a)

new :: a -> List a -> List a
new x list = Item x list

datum :: List a -> a
datum (Item x list) = x

next :: List a -> List a
next (Item x list) = list

toList :: List a -> [a]
toList Empty = []
toList (Item x list) = x : toList list

fromList :: [a] -> List a
fromList [] = Empty
fromList (x:xs) = Item x (fromList xs)

reverseLinkedList :: List a -> List a
reverseLinkedList = fromList . reverse . toList

isNil :: List a -> Bool
isNil Empty = True
isNil _ = False

nil :: List a
nil = Empty
