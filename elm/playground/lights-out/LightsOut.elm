import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List
import Mouse
import Text
import Color
import Window

type alias Model =
  { s : Float -- size
  , p : Float -- padding
  , r : Int   -- rows
  , c : Int   -- coluns
  }

game : Model
game =
  { s = 30
  , p = 3
  , r = 6
  , c = 6
  }

main1 : Element
main1 =
  collage 400 400
            (List.map
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




view : (Int, Int) -> (Int, Int) -> Element
view (x, y) (w, h) =
  collage w h
    [ drawSquare (x - w//2, h//2 - y) (List.head model)
    , drawSquare (x - w//2, h//2 - y) (List.head (List.reverse model))
    , Text.fromString (toString (x - w//2, h//2 - y))
      |> leftAligned
      |> toForm
    ]

type state = ON | OFF

drawSquare : (Int, Int) -> Maybe Square -> Form
drawSquare (x, y) s =
  case s of
    Just s ->
      let
        x1 = (round s.x) - (round (s.size/2))
        y1 = (round s.y) - (round (s.size/2))
        x2 = (round s.x) + (round (s.size/2))
        y2 = (round s.y) + (round (s.size/2))
        color = if x >= x1 && x <= x2 && y >= y1 && y <= y2 then Color.red else Color.blue
      in
        square s.size |> filled color |> move (s.x, s.y)
    Nothing ->
      toForm (spacer 0 0)

main : Signal Element
main =
  Signal.map2 view (Signal.sampleOn Mouse.clicks Mouse.position) Window.dimensions




-- mainClick : Signal Element
-- mainClick =
--   Signal.map show countClick

-- countClick : Signal (Int, Int)
-- countClick =
--   Signal.foldp
--     (\(x, y) (mx, my) -> (x + mx, y + my))
--     (0, 0)
--     (Signal.sampleOn Mouse.clicks Mouse.position)
    