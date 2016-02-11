import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color
import List
import Mouse
import Window

size = 50
padding = 2
num = 5

type alias Game =
  { lights : List Bool }

newGame : Game
newGame =
  { lights = List.map (always False) [1..(num * num)] }

type alias Input =
  { dimension : (Int, Int)
  , click : (Int, Int)
  }

main : Signal Element
main =
  Signal.map2 view Window.dimensions gameState

gameState : Signal Game
gameState =
  Signal.foldp update newGame input

input : Signal Input
input =
  Signal.sampleOn Mouse.clicks
    <| Signal.map2 Input Window.dimensions (Signal.sampleOn Mouse.clicks Mouse.position)


update : Input -> Game -> Game
update {dimension, click} game =
  let
    (w, h) = dimension
    (x, y) = click
    x' = x - w//2 + (size // 2)
    y' = -(y - h//2 - (size // 2))
    target = clicked (x',y')
    newLights =
      if target > -1 then
        List.indexedMap (toggle target) game.lights
      else
        game.lights
  in
    { game |
      lights = newLights
    }

clicked : (Int, Int) -> Int
clicked (x, y) =
  let
    xindex = x // size
    yindex = y // size
  in
    if x <= 0 || y <= 0 || x > num * size || y > num * size then
      -1
    else
      xindex + (yindex * num)

toggle : Int -> Int -> Bool -> Bool
toggle target index value =
  if ((index == 0 || index % num /= num - 1) && index == target - 1) ||
    ((index == (num * num) - 1 || index % num /= 0) && index == target + 1) ||
    index == target + num ||
    index == target - num ||
    index == target then
    not value
  else
    value


view : (Int, Int) -> Game -> Element
view (w, h) game =
  collage w h (List.indexedMap drawSquare game.lights)

drawSquare : Int -> Bool -> Form
drawSquare index state =
  let
    color = if state then Color.red else Color.blue
    x = (index % num) * size
    y = (index // num) * size
  in
    square (size - (padding * 2))
      |> filled color
      |> move (toFloat x, toFloat y)
