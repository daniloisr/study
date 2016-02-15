-- for index query
-- http://programmers.stackexchange.com/a/131705/50321
import Graphics.Collage exposing (Form, collage, square, filled, move, toForm)
import Graphics.Element exposing (Element, show)
import Color exposing (red, rgba)
import List exposing (map, map2, repeat, concat, (::))
import Signal
import Mouse
import Time

type alias Point =
  { x: Int
  , y: Int
  , hover: Float
  , clicked: Bool
  }

p : Int -> Int -> Point
p x y =
  { x = x
  , y = y
  , hover = 0
  , clicked = False
  }

type alias Model =
  { points: List Point
  , input: Input
  }

type alias Input =
  { mousep: (Int,Int)
  , delta: Time.Time
  , clicked: Bool
  }

initialModel : Model
initialModel =
  let
    xs = concat <| map (repeat 5) [0..4]
    ys = concat <| repeat 5 [0..4]
  in
    { points = map2 p xs ys
    , input = { mousep = (0, 0), delta = 0, clicked = False }
    }

paintSquare : Point -> Form
paintSquare point =
  square 50 |>
    filled (if point.clicked then red else (rgba 0 0 0 point.hover)) |>
    move (toFloat point.x * 52, toFloat point.y * 52)

main : Signal Element
main =
  Signal.map
    (\model ->
      map paintSquare model.points
        |> (::) (show model.input |> toForm |> move (-20, -100))
        |> collage 500 500
    )
    currentModel

currentModel : Signal Model
currentModel =
  Signal.foldp update initialModel input

input : Signal Input
input =
  Signal.map3 Input
    Mouse.position
    (Time.fps 1 |> Signal.map Time.inSeconds)
    (Signal.dropRepeats Mouse.isDown)

update : Input -> Model -> Model
update {mousep, delta, clicked} model =
  let
    (x', y') = mousep
    (x, y) = (x' - 225, 275 - y')
    px = x // 50
    py = y // 50
    points = map (\p ->
        if p.x == px && p.y == py then
          { p |
            hover = 1,
            clicked = if clicked then not p.clicked else p.clicked }
        else
          { p |
            hover = max (p.hover - 0.1) 0.3 }
      )
      model.points
  in
    { model |
      input = { mousep = (x, y), delta = 0, clicked = clicked },
      points = points
    }