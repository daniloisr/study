package main

import (
	"fmt"
	"time"

	"github.com/gopherjs/gopherjs/js"
)

type v2 struct {
	x, y int
}

var d, bs v2
var grid = 10

func main() {
	doc := js.Global.Get("document")
	body := doc.Get("body")
	canvas := doc.Call("createElement", "canvas")
	ctx := canvas.Call("getContext", "2d")

	d = setupElements(body, canvas)
	bs = v2{d.x / grid, d.y / grid}

	ticker := *time.NewTicker(1000 / 24 * time.Millisecond)
	draw := makeDraw(ctx)

	go func() {
		for {
			select {
			case <-ticker.C:
				draw()
			}
		}
	}()

	draw()
}

func makeDraw(ctx *js.Object) func() {
	inc := 0.0
	return func() {
		for x := 0; x < grid; x++ {
			for y := 0; y < grid; y++ {
				b := ((y+int(inc))%grid)*8 + x*8
				ctx.Set("fillStyle", fmt.Sprintf("#0000%.2x", 100+(b%156)))
				ctx.Call("fillRect", x*bs.x, y*bs.y, bs.x, bs.y)
			}
		}
		inc = (inc + 0.5)
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
