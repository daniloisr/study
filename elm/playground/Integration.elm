module Integration where

import Graphics.Element exposing (..)
import Signal exposing ((<~))
import String

port documentLoaded : Signal ()

port print : Signal (Maybe Int)
port print =
  (always Nothing) <~ documentLoaded
