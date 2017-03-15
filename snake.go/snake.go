package main

import (
	"github.com/gopherjs/gopherjs/js"
)

type v2 struct {
	x, y int
}

func (a v2) add(b v2) v2 {
	a.x += b.x
	a.y += b.y
	return a
}

func (a v2) mod(x int) v2 {
	a.x = a.x % x
	a.y = a.y % x
	return a
}

var d, bs v2
var grid = 10
var dir = v2{x: 1, y: 0}
var x func(o *js.Object)
var lastTick int64
var counter int

func main() {
	doc := js.Global.Get("document")
	body := doc.Get("body")
	canvas := doc.Call("createElement", "canvas")
	ctx := canvas.Call("getContext", "2d")

	d = setupElements(body, canvas)
	bs = v2{d.x / grid, d.y / grid}
	lastTick = 0
	counter = 0

	head := []v2{{x: 0, y: 2}}

	x = func(o *js.Object) {
		if v := o.Int64(); v-lastTick > 1000/10 {
			tick(ctx, head)
			oldhead := head[0]
			newhead := oldhead.
				add(dir).
				add(v2{grid, grid}).
				mod(grid)

			if counter++; counter > 5 {
				counter = 0
				head = append([]v2{newhead}, head...)
			} else {
				head = append([]v2{newhead}, head[:len(head)-1]...)
			}

			lastTick = o.Int64()
		}

		js.Global.Call("requestAnimationFrame", x)
	}

	js.Global.Call("addEventListener", "keydown", handler, true)
	js.Global.Call("requestAnimationFrame", x)
}

func handler(o *js.Object) {
	switch o.Get("code").String() {
	case "KeyE":
		dir = v2{x: 0, y: -1}
		o.Call("preventDefault")
	case "KeyD":
		dir = v2{x: 0, y: 1}
		o.Call("preventDefault")
	case "KeyS":
		dir = v2{x: -1, y: 0}
		o.Call("preventDefault")
	case "KeyF":
		dir = v2{x: 1, y: 0}
		o.Call("preventDefault")
	}

}

func tick(ctx *js.Object, head []v2) {
	ctx.Call("clearRect", 0, 0, bs.x*grid, bs.y*grid)
	ctx.Set("fillStyle", "black")
	for _, p := range head {
		ctx.Call("fillRect", p.x*bs.x, p.y*bs.y, bs.x, bs.y)
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
	x := w
	if x > h {
		x = h
	}

	canvas.Set("width", x)
	canvas.Set("height", x)

	body.Call("appendChild", canvas)

	return v2{x, x}
}
