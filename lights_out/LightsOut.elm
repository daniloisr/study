-- for index query
-- http://programmers.stackexchange.com/a/131705/50321
import Graphics.Collage exposing (Form, collage, rect, filled, move, toForm)
import Graphics.Element exposing (Element, show, below, container, middle)
import Graphics.Input exposing (button)
import Color exposing (rgb, grayscale)
import List exposing (map, map2, repeat, concat, (::), member)
import Signal
import Mouse
import Time
import Window

gridSize = 5
padding = 2

tupOp : (a -> b -> Int) -> (a, a) -> (b, b) -> (Int, Int)
tupOp op (x, y) (i, j) = (op x i, op y j)

type Input = MouseMove (Int, Int) | TimeDelta Float | MouseClick (Int, Int) | Reset | NoOp

resetButton : Signal.Mailbox Input
resetButton = Signal.mailbox NoOp

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
    range = [0..(gridSize - 1)]
    xs = concat <| map (repeat gridSize) range
    ys = concat <| repeat gridSize range
  in
    { points = map2 p xs ys }

paintSquare : (Int, Int) -> Point -> Form
paintSquare (boardW, boardH) point =
  let
    (r, g, b) = (255, round (30 * point.highlight), round (30 * point.highlight))
    (rectW, rectH) = (boardW//gridSize - padding*2, boardH//gridSize - padding*2)
    (mx, my) =
      (point.x, point.y)
        |> tupOp (*) (rectW, rectH)
        |> tupOp (-) (boardW//2, boardH//2)
        |> tupOp (-) (rectW//2, rectH//2)
        |> tupOp (+) (padding, padding)
  in
    rect (toFloat rectW - padding) (toFloat rectH - padding)
      |> filled (if point.clicked then rgb r g b else grayscale (point.highlight * (-0.05) + 0.6))
      |> move (toFloat mx, toFloat my)

main : Signal Element
main =
  Signal.map2
    view
    Window.dimensions
    currentModel

view : (Int, Int) -> Model -> Element
view (w, h) model =
  let
    (boardW, boardH) = (round ((toFloat w)*0.8 - padding*2), round ((toFloat h)*0.8 - padding*2))
    btn = (button (Signal.message resetButton.address Reset) "reset")
  in
    map (paintSquare (boardW, boardH)) model.points
      |> collage boardW (boardH - 60)
      |> container w (h - 60) middle
      |> below (container w 60 middle btn)

currentModel : Signal Model
currentModel =
  Signal.foldp update initialModel input

input : Signal Input
input =
  Signal.mergeMany [
    (Signal.map MouseMove Mouse.position),
    (Signal.map MouseClick (Signal.sampleOn Mouse.clicks Mouse.position)),
    (Signal.map TimeDelta (Time.fps 30)),
    resetButton.signal
  ]

update : Input -> Model -> Model
update input model =
  case input of
    MouseMove pos ->
      { model | points = map (\p -> { p | hover = (p.x, p.y) == (correctMousePosition pos) }) model.points }

    MouseClick pos ->
      let
        (x, y) = correctMousePosition pos
        affected = map (\(cx, cy) -> (cx + x, cy + y)) [(0, 0), (-1, 0), (0, 1), (1, 0), (0, -1)]
        points =
          map
          (\p -> if member (p.x, p.y) affected then { p | clicked = not p.clicked } else p)
          model.points
      in
        { model | points = points }

    TimeDelta dt ->
      { model |
        points =
          map
          (\p -> { p | highlight = if p.hover then 1 else max (p.highlight - 0.08) 0 })
          model.points
      }

    Reset -> initialModel

    NoOp -> model

correctMousePosition : (Int, Int) -> (Int, Int)
correctMousePosition (x, y) =
  ((x - 225) // 50, (275 - y) // 50)
