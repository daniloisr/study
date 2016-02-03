import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List exposing (repeat, map)
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
            (map
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
    [ square (x, y)
    , Text.fromString (toString (x, y))
      |> leftAligned
      |> toForm
    ]

square : (Int, Int) -> Form
square (x, y) =
  let
    color = if x < 500 && y < 500 then Color.green else Color.blue
  in
    rect 100 100 |> filled color

main : Signal Element
main =
  Signal.map2 view (Signal.sampleOn Mouse.clicks Mouse.position) Window.dimensions




mainClick : Signal Element
mainClick =
  Signal.map show countClick

countClick : Signal (Int, Int)
countClick =
  Signal.foldp
    (\(x, y) (mx, my) -> (x + mx, y + my))
    (0, 0)
    (Signal.sampleOn Mouse.clicks Mouse.position)
    