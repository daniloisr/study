-- for index query
-- http://programmers.stackexchange.com/a/131705/50321
import Graphics.Collage exposing (Form, collage, square, filled, move)
import Graphics.Element exposing (Element)
import Color exposing (gray, black)
import List exposing (map, map2, repeat, concat)
import Signal
import Mouse
import Time

type alias Point =
  { x: Int
  , y: Int
  }

p : Int -> Int -> Point
p x y =
  { x = x
  , y = y
  }

type alias Model =
  { points: List Point
  , hover: List Float
  , clicked: List Bool
  }

type alias Input =
  { mousep: (Int,Int)
  , delta: Time.Time
  }

initialModel : Model
initialModel =
  let
    xs = concat <| map (repeat 3) [0..2]
    ys = concat <| repeat 3 [0..2]
  in
    { points = map2 p xs ys
    , hover = repeat 9 0
    , clicked = repeat 9 False
    }

paintSquare : Point -> Form
paintSquare point =
  square 20 |> filled gray |> move ((toFloat point.x * 22), (toFloat point.y * 22))

main : Signal Element
main =
  Signal.map
    (\x -> collage 300 300 (map paintSquare initialModel.points))
    currentModel

currentModel : Signal Model
currentModel =
  Signal.foldp (flip always) initialModel input

input : Signal Input
input =
  Signal.map2 Input Mouse.position (Time.fps 50 |> Signal.map Time.inSeconds)