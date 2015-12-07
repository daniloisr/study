import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List exposing (repeat, map)

type alias Model =
  { s : Float
  , p : Float
  , r : Int
  , c : Int
  }

game : Model
game =
  { s = 30
  , p = 3
  , r = 6
  , c = 6
  }

main : Element
main =
  collage 400 400
            (map
             (\count ->
                let
                  distance = game.s + game.p
                  x = toFloat(count // game.r) * distance
                  y = toFloat(count % game.r) * distance
                in
                  rect game.s game.s
                    |> filled alphaBlue
                    |> move (x - 180, y + 15)
             )
             [0..((game.r * game.c) - 1)])

alphaBlue : Color
alphaBlue =
  rgb 100 100 200
