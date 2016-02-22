-- for index query
-- http://programmers.stackexchange.com/a/131705/50321
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Graphics.Input exposing (button)
import Text
import Color exposing (rgb, grayscale, black, white)
import List exposing (map, map2, repeat, concat, (::), member, all)
import Signal
import Mouse
import Time exposing (Time)
import Window
import Random

gridSize = 5
padding = 2

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
  , hover: Float
  , highlight: Float
  , clicked: Bool
  , toggled: Bool
  }

point : Int -> Int -> Point
point i j =
  { i = i
  , j = j
  , hover = 0
  , highlight = 0
  , clicked = False
  , toggled = False
  }

type alias RndSetup =
  { clicks: Int
  , seed: Random.Seed
  , rndInt: Int
  }

initRndSetup : RndSetup
initRndSetup =
  { clicks = round <| gridSize * gridSize * 0.4
  , seed = Random.initialSeed -1
  , rndInt = -1
  }

type alias Model =
  { points: List Point
  , clicks: Int
  , window: (Int, Int)
  , randomizing: Bool
  , rndSetup: RndSetup
  , ended: Bool
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
    { points = map2 point xs ys
    , clicks = 0
    , window = win'
    , randomizing = True
    , rndSetup = initRndSetup
    , ended = False
    }


boardSize : Model -> Float
boardSize model =
  (uncurry min) model.window |> toFloat |> (*) 0.6

resetBtnMargin : Int -> Int
resetBtnMargin h = round <| toFloat h * 0.2

-- View
view : Model -> Element
view model =
  let
    (w, h) = model.window
    rmargin = resetBtnMargin h
    bsize = boardSize model
    btn = (button (Signal.message resetButton.address Reset) "reset")
    clicks = txt black <| (toString model.clicks) ++ " clicks"
    board = if model.ended then
        [ toForm << txt white
         <| "Won with " ++ (toString model.clicks) ++ " clicks!"
        ]
      else
        map (paintSquare bsize) model.points
  in
    board
      |> (color (grayscale 0.8) << collage (round bsize) (round bsize))
      |> container w (h - rmargin) middle
      |> below (container w (rmargin//2) midTop clicks)
      |> below (container w (rmargin//2) midTop btn)

txt c string =
  Text.fromString string
    |> Text.color c
    |> Text.monospace
    |> leftAligned

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
  randomize input
    <| play input
    <| updateState input model

randomize input model =
  if not model.randomizing then model
  else case input of
    Tick time -> randomClick time model
    _ -> model

play input model =
  if model.randomizing || model.ended then model
  else case input of
    Move pos ->
      { model
      | points = map
        (\p -> { p | hover = if (p.i, p.j) == (mouseToIndex pos model) then 1 else 0 })
        model.points
      }

    Click pos ->
      let
        toggle = toToggle <| mouseToIndex pos model
        points = map
          (\p -> if member (p.i, p.j) toggle then { p | clicked = not p.clicked } else p)
          model.points
        ended = all (not << .clicked) points
      in
        { model | points = points, ended = ended, clicks = model.clicks + 1 }

    _ -> model


updateState input model =
  case input of
    Resize window -> { model | window = window }
    Reset -> initialModel <| Resize model.window
    Tick time ->
      { model
      | points = map
        (\p -> { p | highlight = max p.hover <| p.highlight - 0.08 })
        model.points
      }
    _ -> model



toToggle : (Int, Int) -> List (Int, Int)
toToggle (i, j) =
  map (\(i2, j2) -> (i + i2, j + j2)) [(0, 0), (-1, 0), (0, 1), (1, 0), (0, -1)]


mouseToIndex : (Int, Int) -> Model -> (Int, Int)
mouseToIndex mouse model =
  let
    (w, h) = model.window
    rmargin = resetBtnMargin h |> toFloat
    bsize = boardSize model
    squareSize = bsize/gridSize
    (x, y) = (\(x, y) -> (toFloat x, toFloat y)) mouse
    (i, j) =
      ( x - (toFloat w - bsize + squareSize          )/2
      ,-y + (toFloat h + bsize - squareSize - rmargin)/2
      )
  in
    (round <| i/squareSize, round <| j/squareSize)

randomClick : Time -> Model -> Model
randomClick t m =
  let
    (rnd, s) =
      Random.generate (Random.int 0 (gridSize * gridSize))
      <| if m.rndSetup.rndInt == -1 then (Random.initialSeed <| round t) else m.rndSetup.seed
    toggle = toToggle (rnd//gridSize, rnd%gridSize)
    points = map (\p -> if member (p.i, p.j) toggle then { p | clicked = not p.clicked } else p) m.points
    rndSetup = { seed = s, rndInt = rnd, clicks = m.rndSetup.clicks - 1 }
  in
    { m | points = points, rndSetup = rndSetup, randomizing = rndSetup.clicks > 0 }


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
    , Signal.map (Tick << fst) (Time.fps 30 |> Time.timestamp)
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