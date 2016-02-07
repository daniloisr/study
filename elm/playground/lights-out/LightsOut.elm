import Color
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import List
import Mouse
import Color
import Window

size = 50
padding = 2
num = 3

main : Signal Element
main =
  Signal.map2 view (Signal.sampleOn Mouse.clicks Mouse.position) Window.dimensions

type State = ON | OFF

model : List State
model =
  List.map (always OFF) [1..(num * num)]

view : (Int, Int) -> (Int, Int) -> Element
view (x, y) (w, h) =
  let
    x' = x - w//2 + (size // 2)
    y' = y - h//2 - (size // 2)
  in
    collage w h
      (List.append
        (List.indexedMap (drawSquare (x', -y')) model)
        [toForm <| show (x', -y')])

drawSquare : (Int, Int) -> Int -> State -> Form
drawSquare (mx, my) index state =
  let
    color = if (clicked (mx, my) index) then Color.red else Color.blue
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
    b1 && b2 && b3