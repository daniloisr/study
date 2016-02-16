-- for index query
-- http://programmers.stackexchange.com/a/131705/50321
import Graphics.Collage exposing (Form, collage, square, filled, move, toForm)
import Graphics.Element exposing (Element, show)
import Color exposing (rgb)
import List exposing (map, map2, repeat, concat, (::))
import Signal
import Mouse
import Time

type Input = MouseMove (Int, Int) | TimeDelta Float | MouseClick (Int, Int)

type alias Point =
  { x: Int
  , y: Int
  , hover: Bool
  , clicked: Bool
  , highlight: Float
  }

p : Int -> Int -> Point
p x y =
  { x = x
  , y = y
  , hover = False
  , clicked = False
  , highlight = 0
  }

type alias Model =
  { points: List Point }

initialModel : Model
initialModel =
  let
    xs = concat <| map (repeat 5) [0..4]
    ys = concat <| repeat 5 [0..4]
  in
    { points = map2 p xs ys }

paintSquare : Point -> Form
paintSquare point =
  square 50 |>
    filled
      (if point.clicked then
        (rgb 255 (round (50 * point.highlight)) (round (50 * point.highlight)))
      else
        (rgb (round (180 * (1 - point.highlight))) (round (180 * (1 - point.highlight))) (round (180 * (1 - point.highlight))))) |>
    move (toFloat point.x * 52, toFloat point.y * 52)

main : Signal Element
main =
  Signal.map
    (\model ->
      map paintSquare model.points
        -- |> (::) (show model.input |> toForm |> move (-20, -100))
        |> collage 500 500
    )
    currentModel

currentModel : Signal Model
currentModel =
  Signal.foldp update initialModel input

input : Signal Input
input =
  Signal.mergeMany [
    (Signal.map MouseMove Mouse.position),
    (Signal.map MouseClick (Signal.sampleOn Mouse.clicks Mouse.position)),
    (Signal.map TimeDelta (Time.fps 30))
  ]

update : Input -> Model -> Model
update input model =
  case input of
    MouseMove pos ->
      let
        (x, y) = correctMousePosition pos
        points =
          map
          (\p -> { p | hover = p.x == x && p.y == y })
          model.points
      in
        { model | points = points }
    MouseClick pos ->
      let
        (x, y) = correctMousePosition pos
        points =
          map
          (\p -> if p.x == x && p.y == y then { p | clicked = not p.clicked } else p)
          model.points
      in
        { model | points = points }
    TimeDelta dt ->
      { model |
        points =
          map
          (\p -> { p | highlight = if p.hover then 1 else max (p.highlight - 0.2) 0 })
          model.points
      }

correctMousePosition : (Int, Int) -> (Int, Int)
correctMousePosition (x, y) =
  ((x - 225) // 50, (275 - y) // 50)
