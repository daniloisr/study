-- for index query
-- http://programmers.stackexchange.com/a/131705/50321
import Graphics.Collage exposing (Form, collage, square, filled, move, toForm)
import Graphics.Element exposing (Element, show, below, container, middle, color)
import Graphics.Input exposing (button)
import Color exposing (rgb, grayscale, black)
import List exposing (map, map2, repeat, concat, (::), member)
import Signal
import Mouse
import Time
import Window

gridSize = 5
padding = 2
resetBtnMargin = 60

type Input = Move (Int, Int)
           | Click (Int, Int)
           | Resize (Int, Int)
           | Tick
           | Reset
           | NoOp

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
  { points: List Point
  , window: (Int, Int)
  }

initialModel : Model
initialModel =
  let
    range = [0..(gridSize - 1)]
    xs = concat <| map (repeat gridSize) range
    ys = concat <| repeat gridSize range
  in
    { points = map2 p xs ys
    , window = (0, 0) }

boardSize : Model -> Float
boardSize model =
  let
    (w, h) = model.window
  in
    min w h |> toFloat |> (*) 0.6


-- View
view : Model -> Element
view model =
  let
    (w, h) = model.window
    bsize = boardSize model
    btn = (button (Signal.message resetButton.address Reset) "reset")
  in
    map (paintSquare bsize) model.points
      |> (color (grayscale 0.8) << collage (round bsize) (round bsize))
      |> container w (h - resetBtnMargin) middle
      |> below (container w resetBtnMargin middle btn)


paintSquare : Float -> Point -> Form
paintSquare bsize point =
  let
    (r, g, b) = (round (30 * point.highlight) + 50, round (30 * point.highlight) + 50, 200)
    squareSize = bsize/gridSize
    (mx, my) =
      ((toFloat point.x) * squareSize - (bsize - squareSize)/2
      ,(toFloat point.y) * squareSize - (bsize - squareSize)/2
      )
  in
    square (squareSize - padding)
      |> filled (if point.clicked then rgb r g b else grayscale (point.highlight * (-0.05) + 0.6))
      |> move (mx, my)


-- Update
input : Signal Input
input =
  Signal.mergeMany
    [ Signal.map Resize Window.dimensions
    , Signal.map Move Mouse.position
    , Signal.map Click (Signal.sampleOn Mouse.clicks Mouse.position)
    , Signal.map (always Tick) (Time.fps 30)
    , resetButton.signal
    ]


update : Input -> Model -> Model
update input model =
  case input of
    Move pos ->
      { model | points = map (\p -> { p | hover = (p.x, p.y) == (mouseToIndex pos model) }) model.points }

    Click pos ->
      let
        (x, y) = mouseToIndex pos model
        affected = map (\(cx, cy) -> (cx + x, cy + y)) [(0, 0), (-1, 0), (0, 1), (1, 0), (0, -1)]
        points =
          map
          (\p -> if member (p.x, p.y) affected then { p | clicked = not p.clicked } else p)
          model.points
      in
        { model | points = points }

    Resize window -> { model | window = window }

    Tick ->
      { model |
        points =
          map
          (\p -> { p | highlight = if p.hover then 1 else max (p.highlight - 0.08) 0 })
          model.points
      }

    Reset -> initialModel

    NoOp -> model


mouseToIndex : (Int, Int) -> Model -> (Int, Int)
mouseToIndex mouse model =
  let
    (w, h) = model.window
    bsize = boardSize model
    squareSize = bsize/gridSize
    (x, y) = (\(x, y) -> (toFloat x, toFloat y)) mouse
    (ix, iy) =
      ( x - (toFloat w - bsize + squareSize                 )/2
      ,-y + (toFloat h + bsize - squareSize - resetBtnMargin)/2
      )
  in
    (round <| ix/squareSize, round <| iy/squareSize)


-- Main
main : Signal Element
main =
  Signal.map view <| Signal.foldp update initialModel input
