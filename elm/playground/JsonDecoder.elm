module JsonDecoder where

import Native.JsonDecoder

import Task exposing (Task, andThen)
import Signal exposing (Mailbox, mailbox, send, map)
import Html exposing (Html, text)
import Json.Decode
import String exposing (append)
import List exposing (foldr)

box : Mailbox (List String)
box =
  mailbox ["loading"]

getArray : Task x (List String)
getArray =
  Native.JsonDecoder.getArray

port runner : Task x ()
port runner =
  andThen getArray (send box.address)

main : Signal Html
main =
  map (\x -> text (foldr append "" x)) box.signal
