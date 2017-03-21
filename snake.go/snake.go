package main

import (
	"fmt"
	"math/rand"
	"time"

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
	return v2{a.x % x, a.y % x}
}

func (a v2) div(x int) v2 {
	return v2{a.x / x, a.y / x}
}

var (
	grid     = 10
	lastTick int64
	ctx      *js.Object
	d, bs    v2
	dir      v2
	food     v2
	head     []v2
	dirbuf   []v2
)

func main() {
	rand.Seed(time.Now().Unix())

	d, ctx = setupElements()
	bs = d.div(grid)

	initVars()

	js.Global.Call("addEventListener", "keydown", handler, true)
	js.Global.Call("requestAnimationFrame", tick)
}

func initVars() {
	dir = v2{1, 0}
	lastTick = 0

	head = []v2{{0, 2}}
	food = randomFood()
}

func randomFood() v2 {
	return v2{rand.Intn(grid), rand.Intn(grid)}
}

func handler(o *js.Object) {
	dirs := map[string]struct {
		dir     v2
		oposite string
	}{
		"KeyE": {v2{0, -1}, "KeyD"},
		"KeyD": {v2{0, 1}, "KeyE"},
		"KeyS": {v2{-1, 0}, "KeyF"},
		"KeyF": {v2{1, 0}, "KeyS"},
	}

	if val, ok := dirs[o.Get("code").String()]; ok {
		var lastdir v2

		if len(dirbuf) == 0 {
			lastdir = dir
		} else {
			lastdir = dirbuf[len(dirbuf)-1]
		}

		oposite := dirs[val.oposite].dir
		if lastdir != oposite && lastdir != val.dir {
			dirbuf = append(dirbuf, val.dir)
		}

		o.Call("preventDefault")
	}
}

func tick(o *js.Object) {
	if v := o.Int64(); v-lastTick > 1000/6 {
		if len(dirbuf) > 0 {
			dir, dirbuf = dirbuf[0], dirbuf[1:]
		}

		oldhead := head[0]
		newhead := oldhead.add(dir)

		invalid := false
		for _, segment := range head {
			invalid = newhead == segment
			invalid = invalid || newhead.x < 0 || newhead.x >= grid
			invalid = invalid || newhead.y < 0 || newhead.y >= grid

			if invalid {
				break
			}
		}

		if food == newhead {
			head = append([]v2{newhead}, head...)
			food = randomFood()
		} else {
			head = append([]v2{newhead}, head[:len(head)-1]...)
		}

		if invalid {
			initVars()
		}

		draw()
		lastTick = o.Int64()
	}

	js.Global.Call("requestAnimationFrame", tick)
}

func draw() {
	ctx.Set("fillStyle", "#dfdfdf")
	ctx.Call("fillRect", 0, 0, bs.x*grid, bs.y*grid)
	ctx.Set("fillStyle", "red")
	ctx.Call("fillRect", food.x*bs.x+3, food.y*bs.y+3, bs.x-6, bs.y-6)
	ctx.Set("fillStyle", "black")
	for _, p := range head {
		ctx.Call("fillRect", p.x*bs.x+2, p.y*bs.y+2, bs.x-4, bs.y-4)
	}
}

func setupElements() (v2, *js.Object) {
	doc := js.Global.Get("document")
	body := doc.Get("body")
	canvas := doc.Call("createElement", "canvas")

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
	biggest := w
	if biggest > h {
		biggest = h
	}

	size := int(float32(biggest) * 0.9)
	marginLeft := (w - size) / 2
	if marginLeft < 0 {
		marginLeft = 0
	}

	canvas.Set("width", size)
	canvas.Set("height", size)
	canvas.Get("style").Set("margin-top", fmt.Sprintf("%dpx", int(float32(biggest)*0.05)))
	canvas.Get("style").Set("margin-left", fmt.Sprintf("%dpx", int(marginLeft)))

	body.Call("appendChild", canvas)

	return v2{size, size}, canvas.Call("getContext", "2d")
}
