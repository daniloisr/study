import Graphics.Collage exposing (Form, collage, square, filled, move)
import Graphics.Element exposing (Element)
import Color exposing (gray, black)
import List exposing (map, map2, repeat, concat)

type alias Point =
  { x: Int
  , y: Int
  }

p : Int -> Int -> Point
p x y =
  { x = x
  , y = y
  }


points : List Point
points =
  let
    xs = concat <| map (repeat 3) [0..2]
    ys = concat <| repeat 3 [0..2]
  in
    map2 p xs ys

paintSquare : Point -> Form
paintSquare point =
  square 20 |> filled gray |> move ((toFloat point.x * 22), (toFloat point.y * 22))

main : Element
main =
  collage 300 300
    (map paintSquare points)