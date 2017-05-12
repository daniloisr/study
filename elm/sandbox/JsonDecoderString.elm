module JsonDecoderString where

import Html as Html
import Json.Decode exposing (decodeString, string)
import String

main : Html.Html
main = Html.text decode

decode : String
decode =
  case decodeString string "\"Teste\"" of
    Ok v -> v
    Err msg -> msg
