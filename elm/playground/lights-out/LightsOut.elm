import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Color
import List
import Mouse
import Window

size = 50
padding = 2
num = 3

main : Signal Element
main =
  Signal.map2 view Window.dimensions gameState

gameState : Signal Game
gameState =
  Signal.foldp update newGame (Signal.sampleOn Mouse.clicks Mouse.position)

update : (Int, Int) -> Game -> Game
update (x, y) game =
  let
    x = 1
    -- x' = x - w//2 + (size // 2)
    -- y' = y - h//2 - (size // 2)
  in
    -- collage w h
    --   (List.append
    --     (List.indexedMap (drawSquare (x', -y')) game.ligths)
    --     [toForm <| show (x', -y')])
    game

type alias Game =
  { lights : List Bool }

newGame : Game
newGame =
  { lights = List.map (always False) [1..(num * num)] }

view : (Int, Int) -> Game -> Element
view (w, h) game =
  collage w h (List.indexedMap drawSquare game.lights)

drawSquare : Int -> Bool -> Form
drawSquare index state =
  let
    color = if False then Color.red else Color.blue
    x = (index % num) * size
    y = (index // num) * size
  in
    square (size - (padding * 2)) |> filled color |> move (toFloat x, toFloat y)

clicked : (Int, Int) -> Int -> Bool
clicked (mx, my) index =
  let
    ix = index % num
    iy = index // num
    (mx', my') = (mx % size, my % size)
    b1 = mx // size == ix && my // size == iy
    b2 = mx' - padding > 0 && my' - padding > 0
    b3 = mx' + padding < size && my' + padding < size
  in
    mx > 0 && my > 0 && b1 && b2 && b3