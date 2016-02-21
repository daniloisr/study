-- for index query
-- http://programmers.stackexchange.com/a/131705/50321
import Graphics.Collage exposing (Form, collage, square, filled, move, toForm)
import Graphics.Element exposing (Element, show, below, container, middle, color)
import Graphics.Input exposing (button)
import Color exposing (rgb, grayscale, black)
import List exposing (map, map2, repeat, concat, (::), member)
import Signal
import Mouse
import Time exposing (Time)
import Window
import Random

gridSize = 5
padding = 2
resetBtnMargin = 60

type Input = Move (Int, Int)
           | Click (Int, Int)
           | Resize (Int, Int)
           | Tick Time
           | Reset

resetButton : Signal.Mailbox Input
resetButton = Signal.mailbox Reset


type alias Point =
  { i: Int
  , j: Int
  , hover: Bool
  , clicked: Bool
  , highlight: Float
  }

p : Int -> Int -> Point
p i j =
  { i = i
  , j = j
  , hover = False
  , clicked = False
  , highlight = 0
  }


type alias Model =
  { points: List Point
  , window: (Int, Int)
  , random: Int
  , seed: Random.Seed
  , i: Int
  }

initialModel : Input -> Model
initialModel input =
  let
    range = [0..(gridSize - 1)]
    xs = concat <| map (repeat gridSize) range
    ys = concat <| repeat gridSize range
    win' = case input of
      Resize win -> win
      _ -> (0, 0)
  in
    { points = map2 p xs ys
    , window = win'
    , random = gridSize * gridSize * 0.5 |> round
    , seed = Random.initialSeed -1
    , i = -1
    }


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
      ((toFloat point.i) * squareSize - (bsize - squareSize)/2
      ,(toFloat point.j) * squareSize - (bsize - squareSize)/2
      )
  in
    square (squareSize - padding)
      |> filled (if point.clicked then rgb r g b else grayscale (point.highlight * (-0.05) + 0.6))
      |> move (mx, my)


-- Update
update : Input -> Model -> Model
update input model =
  case input of
    Move pos ->
      if model.random == 0 then
        { model | points = map (\p -> { p | hover = (p.i, p.j) == (mouseToIndex pos model) }) model.points }
      else
        model

    Click pos ->
      let
        toggle = toToggle <| mouseToIndex pos model
        points = map (\p -> if member (p.i, p.j) toggle then { p | clicked = not p.clicked } else p) model.points
      in
        if model.random == 0 then
          { model | points = points }
        else
          model

    Resize window -> { model | window = window }

    Tick time ->
      if model.random == 0 then
        { model | points = map (\p -> { p | highlight = if p.hover then 1 else max (p.highlight - 0.08) 0 }) model.points }
      else
        randomClick time model

    Reset -> initialModel <| Resize model.window


toToggle : (Int, Int) -> List (Int, Int)
toToggle (i, j) =
  map (\(i2, j2) -> (i + i2, j + j2)) [(0, 0), (-1, 0), (0, 1), (1, 0), (0, -1)]


mouseToIndex : (Int, Int) -> Model -> (Int, Int)
mouseToIndex mouse model =
  let
    (w, h) = model.window
    bsize = boardSize model
    squareSize = bsize/gridSize
    (x, y) = (\(x, y) -> (toFloat x, toFloat y)) mouse
    (i, j) =
      ( x - (toFloat w - bsize + squareSize                 )/2
      ,-y + (toFloat h + bsize - squareSize - resetBtnMargin)/2
      )
  in
    (round <| i/squareSize, round <| j/squareSize)

randomClick : Time -> Model -> Model
randomClick t m =
  let
    (rnd, s) =
      Random.generate (Random.int 0 (gridSize * gridSize))
      <| if m.i == -1 then (Random.initialSeed <| round t) else m.seed
    toggle = toToggle (rnd//gridSize, rnd%gridSize)
    points = map (\p -> if member (p.i, p.j) toggle then { p | clicked = not p.clicked } else p) m.points
  in
    { m | points = points, seed = s, i = rnd, random = m.random - 1 }


-- Main
main : Signal Element
main =
  Signal.map view <| foldp' update initialModel inputs

inputs : Signal Input
inputs =
  Signal.mergeMany
    [ Signal.map Resize Window.dimensions
    , Signal.map Move Mouse.position
    , Signal.map Click (Signal.sampleOn Mouse.clicks Mouse.position)
    , Signal.map (\a -> Tick <| fst a) (Time.fps 30 |> Time.timestamp)
    , resetButton.signal
    ]




-- Foldp that don't drop the first signal
-- ref: https://github.com/Apanatshka/elm-signal-extra/blob/fb8d75a/src/Signal/Extra.elm#L169
-- see: foldp problem: https://groups.google.com/d/topic/elm-discuss/rsCgT_eR9UU/discussion
foldp' : (a -> b -> b) -> (a -> b) -> Signal a -> Signal b
foldp' fun initFun input =
  let
    initial = Signal.map initFun <| (Signal.sampleOn (Signal.constant ()) input)
    rest = Signal.foldp fun' Nothing (Signal.map2 (,) input initial)
    fun' (inp, ini) mb = Maybe.withDefault ini mb |> fun inp |> Just
    unsafe maybe =
      case maybe of
       Just value -> value
       Nothing -> Debug.crash "Should never be here"
  in
    Signal.map unsafe <| Signal.merge (Signal.map Just initial) rest