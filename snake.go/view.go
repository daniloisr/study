package main

import (
	"fmt"

	"github.com/gopherjs/gopherjs/js"
)

var view struct {
	ctx        *js.Object
	canvasSize v2
	cellSize   v2
}

func draw() {
	ctx := view.ctx
	cellSize := view.cellSize
	food := game.food
	body := game.body
	foodCord := food.mul(cellSize).add(v2{3, 3})
	foodSize := cellSize.sub(v2{6, 6})

	ctx.Set("fillStyle", "#dfdfdf")
	ctx.Call("fillRect", 0, 0, view.canvasSize.x, view.canvasSize.y)
	ctx.Set("fillStyle", "red")
	ctx.Call("fillRect", foodCord.x, foodCord.y, foodSize.x, foodSize.y)
	ctx.Set("fillStyle", "black")
	for _, segment := range body {
		segmentCord := segment.mul(cellSize).add(v2{2, 2})
		segmentSize := cellSize.sub(v2{4, 4})
		ctx.Call("fillRect", segmentCord.x, segmentCord.y, segmentSize.x, segmentSize.y)
	}
}

func initView() {
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

	view.canvasSize = v2{size, size}
	view.cellSize = v2{size, size}.div(game.gridSize)
	view.ctx = canvas.Call("getContext", "2d")
}
