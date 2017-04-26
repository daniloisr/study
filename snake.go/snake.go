package main

import (
	"math/rand"
	"time"

	"github.com/gopherjs/gopherjs/js"
)

var game = struct {
	gridSize   int
	level      int
	lastTick   int64
	levelStep  int
	currentDir v2
	food       v2
	body       []v2
	dirbuf     []v2
}{}

func tickInterval(v int64) bool {
	interval := 1000 / (game.level + 8)
	return v-game.lastTick > int64(interval)
}

var initialBody = []v2{{0, 4}, {0, 3}, {0, 2}, {0, 1}}

func newFood() v2 {
	positions := make(map[v2]bool)

	for i := 0; i < game.gridSize; i++ {
		for j := 0; j < game.gridSize; j++ {
			positions[v2{i, j}] = true
		}
	}

	for _, cell := range game.body {
		positions[cell] = false
	}

	var availables []v2

	for cell, available := range positions {
		if available {
			availables = append(availables, cell)
		}
	}

	return availables[rand.Intn(len(availables))]
}

func initGame() {
	game.gridSize = 10
	game.level = 0
	game.lastTick = 0
	game.levelStep = 30
	game.currentDir = v2{1, 0}

	game.body = initialBody
	game.food = newFood()
}

func main() {
	rand.Seed(time.Now().Unix())

	initGame()
	initView()

	js.Global.Call("addEventListener", "keydown", keyHandler, true)
	js.Global.Call("requestAnimationFrame", tick)
}

func keyHandler(o *js.Object) {
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

		if len(game.dirbuf) == 0 {
			lastdir = game.currentDir
		} else {
			lastdir = game.dirbuf[len(game.dirbuf)-1]
		}

		oposite := dirs[val.oposite].dir
		if lastdir != oposite && lastdir != val.dir {
			game.dirbuf = append(game.dirbuf, val.dir)
		}

		o.Call("preventDefault")
	}
}

func tick(o *js.Object) {
	if v := o.Int64(); tickInterval(v) {
		if len(game.dirbuf) > 0 {
			game.currentDir, game.dirbuf = game.dirbuf[0], game.dirbuf[1:]
		}

		oldhead := game.body[0]
		newhead := oldhead.add(game.currentDir)

		var invalid bool
		for _, cell := range game.body {
			invalid = newhead == cell
			invalid = invalid || newhead.x < 0 || newhead.x >= game.gridSize
			invalid = invalid || newhead.y < 0 || newhead.y >= game.gridSize

			if invalid {
				break
			}
		}

		if game.food == newhead {
			game.body = append([]v2{newhead}, game.body...)
			game.food = newFood()
			game.level = (len(game.body) - len(initialBody)) / game.levelStep
		} else {
			game.body = append([]v2{newhead}, game.body[:len(game.body)-1]...)
		}

		if invalid {
			initGame()
		}

		draw()
		game.lastTick = o.Int64()
	}

	js.Global.Call("requestAnimationFrame", tick)
}
