import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List exposing (repeat, map)

type alias Model =
  { s : Int
  , r : Int
  , c : Int
  }

game : Model
game =
  { s = 20
  , r = 2
  , c = 2
  }

main : Element
main =
  collage 400 400
    (map
      (\x -> rect 20 20
        |> filled alphaBlue
        |> move (x*10,-10))
      [0..3])

alphaBlue : Color
alphaBlue =
  rgba 100 100 200 0.1