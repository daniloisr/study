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

var d, bs v2
var grid = 25
var dir = v2{1, 0}
var lastTick int64
var food v2
var ctx *js.Object
var head []v2
var dirbuf []v2

func main() {
	rand.Seed(time.Now().Unix())
	doc := js.Global.Get("document")
	body := doc.Get("body")
	canvas := doc.Call("createElement", "canvas")
	ctx = canvas.Call("getContext", "2d")

	d = setupElements(body, canvas)
	bs = d.div(grid)
	lastTick = 0

	head = []v2{{0, 2}}
	food = randomFood()

	js.Global.Call("addEventListener", "keydown", handler, true)
	js.Global.Call("requestAnimationFrame", tick)
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
		oposite := dirs[val.oposite].dir
		var lastdir v2
		if len(dirbuf) == 0 {
			lastdir = dir
		} else {
			lastdir = dirbuf[len(dirbuf)-1]
		}
		if lastdir != oposite && lastdir != val.dir {
			dirbuf = append(dirbuf, val.dir)
			if len(dirbuf) > 1 {
				fmt.Println(dirbuf)
			}
		}
		o.Call("preventDefault")
	}
}

func tick(o *js.Object) {
	if v := o.Int64(); v-lastTick > 1000/3 {
		draw()
		lastTick = o.Int64()
	}

	js.Global.Call("requestAnimationFrame", tick)
}

func draw() {
	if len(dirbuf) > 0 {
		dir, dirbuf = dirbuf[0], dirbuf[1:]
	}

	oldhead := head[0]
	newhead := oldhead.
		add(dir).
		add(v2{grid, grid}).
		mod(grid)

	if food == newhead {
		head = append([]v2{newhead}, head...)
		food = randomFood()
	} else {
		head = append([]v2{newhead}, head[:len(head)-1]...)
	}

	ctx.Set("fillStyle", "#dfdfdf")
	ctx.Call("fillRect", 0, 0, bs.x*grid, bs.y*grid)
	ctx.Set("fillStyle", "red")
	ctx.Call("fillRect", food.x*bs.x+3, food.y*bs.y+3, bs.x-6, bs.y-6)
	ctx.Set("fillStyle", "black")
	for _, p := range head {
		ctx.Call("fillRect", p.x*bs.x+2, p.y*bs.y+2, bs.x-4, bs.y-4)
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
	biggest := w
	if biggest > h {
		biggest = h
	}

	size := int(float32(biggest) * 0.9)
	marginLeft := (w - biggest) / 2
	if marginLeft < 0 {
		marginLeft = 0
	}

	canvas.Set("width", size)
	canvas.Set("height", size)
	canvas.Get("style").Set("margin-top", fmt.Sprintf("%dpx", int(float32(biggest)*0.05)))
	canvas.Get("style").Set("margin-left", fmt.Sprintf("%dpx", int(marginLeft)))

	body.Call("appendChild", canvas)

	return v2{size, size}
}
