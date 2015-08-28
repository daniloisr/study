module Popup where

import Task exposing (Task, andThen)
import Html exposing (Html)
import Signal exposing (Signal)
import String
import List

port tabs : Signal (List String)

main : Signal Html
main =
  Signal.map
    (\x -> Html.ul [] (view x))
    tabs

view : List String -> List Html
view items =
  List.map (\x -> Html.li [] [Html.text x]) items
