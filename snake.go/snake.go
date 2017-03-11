package main

import "github.com/gopherjs/gopherjs/js"
import "fmt"

type v2 struct {
	x, y int
}

func main() {
	doc := js.Global.Get("document")
	body := doc.Get("body")
	canvas := doc.Call("createElement", "canvas")
	ctx := canvas.Call("getContext", "2d")

	d := setupElements(body, canvas)

	grid := 10
	bs := v2{d.x / grid, d.y / grid}

	for x := 0; x < grid; x++ {
		for y := 0; y < grid; y++ {
			ctx.Set("fillStyle", fmt.Sprintf("#%x%x%x", 50+x*(205/grid), 50+y*(205/grid), 50+(x+y)*(205/(grid*2))))
			ctx.Call("fillRect", x*bs.x, y*bs.y, bs.x, bs.y)
		}
	}
}

func setupElements(body *js.Object, canvas *js.Object) v2 {
	styles := map[string]string{
		"margin":   "0",
		"position": "absolute",
		"top":      "0",
		"bottom":   "0",
		"left":     "0",
		"right":    "0",
		"overflow": "hidden",
	}

	for k, v := range styles {
		body.Get("style").Set(k, v)
	}

	w, h := body.Get("clientWidth").Int(), body.Get("clientHeight").Int()

	canvas.Set("width", w)
	canvas.Set("height", h)

	body.Call("appendChild", canvas)

	return v2{w, h}
}
