module Popup where

import Native.Popup

import Task exposing (Task, andThen)
import Html exposing (Html)
import Signal exposing (Signal)
import String

contentMailbox : Signal.Mailbox String
contentMailbox =
  Signal.mailbox ""

currentTab : Task x String
currentTab =
  Native.Popup.getCurrentTabUrl

port runner : Task x ()
port runner =
  currentTab `andThen` (Signal.send contentMailbox.address)

main : Signal Html
main =
  Signal.map Html.text contentMailbox.signal
