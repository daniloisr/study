module Main where

import Scorer exposing (score)
import Html
import String

main : Html.Html
main =
  score "aabc" "abc"
    |> toString
    |> Html.text
