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

initialLevel = 3
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

buildPoint : Int -> Int -> Point
buildPoint i j =
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

initRndSetup : Int -> RndSetup
initRndSetup s =
  { clicks = round <| toFloat s * toFloat s * 0.4
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
  , level: Int
  }

initialModel : Int -> Input -> Model
initialModel level input =
  let
    win' = case input of
      Resize win -> win
      _ -> (0, 0)
  in
    { points = buildGrid level
    , clicks = 0
    , window = win'
    , randomizing = True
    , rndSetup = initRndSetup level
    , ended = False
    , level = level
    }

buildGrid : Int -> List Point
buildGrid s =
  map (uncurry buildPoint << (\a -> (a//s, a%s)))  [0..((s * s) - 1)]


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
        if model.level < 6 then
          [ toForm << txt white
           <| "Won with " ++ (toString model.clicks) ++ " clicks!"
          ]
        else
          [ toForm << txt white
           <| "Won with " ++ (toString model.clicks) ++ " clicks!\nNow get back to Work!"
          ]
      else
        map (paintSquare bsize model.level) model.points
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

paintSquare : Float -> Int -> Point -> Form
paintSquare bsize level point =
  let
    (r, g, b) = (round (30 * point.highlight) + 50, round (30 * point.highlight) + 50, 200)
    squareSize = bsize/toFloat level
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
  if model.randomizing then model

  else if model.ended then case input of
    Click pos ->
      if model.level < 6 then
        initialModel (min 6 <| model.level + 1) <| Resize model.window
      else
        model
    _ -> model

  else case input of
    Move pos ->
      { model
      | points = map
        (\p -> { p | hover = if (p.i, p.j) == (mouseToIndex pos model) then 1 else 0 })
        model.points
      }

    Click pos ->
      let
        toggle = toToggle model <| mouseToIndex pos model
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
    Reset -> initialModel (if model.level < 6 then model.level else initialLevel) <| Resize model.window
    Tick time ->
      { model
      | points = map
        (\p -> { p | highlight = max p.hover <| p.highlight - 0.08 })
        model.points
      }
    _ -> model



toToggle : Model -> (Int, Int) -> List (Int, Int)
toToggle m (i, j) =
  if m.level == 6 then
    map (\(i2, j2) -> (i + i2, j + j2)) [(0, 0), (-1, -1), (-1, 1), (1, 1), (1, -1)]

  else
    map (\(i2, j2) -> (i + i2, j + j2)) [(0, 0), (-1, 0), (0, 1), (1, 0), (0, -1)]


mouseToIndex : (Int, Int) -> Model -> (Int, Int)
mouseToIndex mouse model =
  let
    (w, h) = model.window
    rmargin = resetBtnMargin h |> toFloat
    bsize = boardSize model
    squareSize = bsize/toFloat model.level
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
      Random.generate (Random.int 0 (m.level * m.level))
      <| if m.rndSetup.rndInt == -1 then (Random.initialSeed <| round t) else m.rndSetup.seed
    toggle = toToggle m (rnd//m.level, rnd%m.level)
    points = map (\p -> if member (p.i, p.j) toggle then { p | clicked = not p.clicked } else p) m.points
    rndSetup = { seed = s, rndInt = rnd, clicks = m.rndSetup.clicks - 1 }
  in
    { m | points = points, rndSetup = rndSetup, randomizing = rndSetup.clicks > 0 }


-- Main
main : Signal Element
main =
  Signal.map view <| foldp' update (initialModel initialLevel) inputs

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