module Main where

import Html exposing (..)
import String


main : Html
main =
  List.map toString lists
    |> List.foldr String.append ""
    |> text


lists : List number
lists = [1, 2, 3]
