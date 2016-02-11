module Integration where

import Html exposing (Html)
import String

port documentLoaded : Signal (List String)

-- port print : Signal (List String)
-- port print =
--   identity <~ documentLoaded

main : Signal Html
main =
  Signal.map
    (\x -> Html.ul [] (view x))
    documentLoaded

-- (Html.div [] (\n -> List.map (\x -> Html.li x) n))

view : List String -> List Html
view items =
  List.map (\x -> Html.li [] [Html.text x]) items
