module Tabs where

import Task exposing (Task, andThen)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Signal, Address)
import Maybe
import String
import List
import Keyboard


type Action
  = NoOp
  | ChangeTab Int
  | KeyPressed Int


type alias Model =
  { tabs : List Tab
  , lastKey : Int
  }


type alias Tab =
  { title : String
  , url : String
  , id : Int
  , active : Bool
  }


main : Signal Html
main =
  Signal.map view model


model : Signal Model
model =
  Signal.foldp
    update
    initialModel
    (Signal.merge
      (Signal.map identity actions.signal)
      (Signal.map KeyPressed Keyboard.presses))


initialModel : Model
initialModel =
  (initModel getTabs)


initModel : List Tab -> Model
initModel tabs =
  { tabs = tabs
  , lastKey = 0
  }


view : Model -> Html
view model =
  div []
    [ ul [] (
        List.map
        (\x ->
          li
          [onClick actions.address (ChangeTab x.id)]
          [text x.title])
        model.tabs)
    , text (toString model.lastKey)
    ]


actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model

    ChangeTab id ->
      let updateTab t = if t.id == id then { t | active = True } else { t | active = False }
      in
        { model | tabs = List.map updateTab model.tabs }

    KeyPressed key ->
      { model | lastKey = key }


keyPressed : Signal Signal.Message
keyPressed =
  Signal.map (\x -> Signal.message actions.address (KeyPressed x)) Keyboard.presses


port changeTab : Signal Model
port changeTab = model


port getTabs : List Tab
