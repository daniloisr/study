module Tabs where

import Task exposing (Task, andThen)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address, (<~))
import Maybe
import String
import List

type Action =
  NoOp

port tabs : Signal (List Tab)

type alias Tab = { title:String, url:String }

main : Signal Html
main =
  Signal.map
    (\x -> ul [] (view x))
    tabs

view : List Tab -> List Html
view items =
  List.map
        (\x ->
          li
          [onClick actions.address NoOp]
          [text x.title])
        items

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

port changeTab : Signal (Maybe Int)
port changeTab =
  (always Nothing) <~ actions.signal
