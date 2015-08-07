module Integration where

import Html exposing (Html)
import String

port documentLoaded : Signal (List String)

-- port print : Signal (List String)
-- port print =
--   identity <~ documentLoaded

main : Signal Html
main =
  Signal.map (\n -> Html.text (List.foldr String.append "" n)) documentLoaded
