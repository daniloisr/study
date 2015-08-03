module Main where

import Scorer exposing (score)
import Html exposing (..)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (on, targetValue)
import String exposing (append)
import Char exposing (fromCode)
import StartApp

main =
  StartApp.start
    { model = ""
    , update = update
    , view = view }

type Action = Input String

type alias Model = String

update : Action -> Model -> Model
update action model =
  case action of
    Input string -> string


view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [
      input
        [ placeholder "filter"
        , on "input" targetValue (Signal.message address << Input)
        ]
        []
    , div [] [ text (filter strings model |> toString) ]
    ]

filter : List String -> Model -> List String
filter strings model =
  List.filter (\a -> (Scorer.score a model) > 0.15) strings

strings : List String
strings =
  [ "Google Searcher"
  , "Duckduckgo Searcher"
  , "Yahoo Searcher"
  ]
