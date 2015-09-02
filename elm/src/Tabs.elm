module Tabs where

import Task exposing (Task, andThen)
import Html exposing (Html)
import Signal exposing (Signal)
import String
import List

port tabs : Signal (List Tab)

type alias Tab = { title:String, url:String }

main : Signal Html
main =
  Signal.map
    (\x -> Html.ul [] (view x))
    tabs

view : List Tab -> List Html
view items =
  List.map (\x -> Html.li [] [Html.text x.title]) items
