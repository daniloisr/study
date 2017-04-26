package main

type v2 struct {
	x, y int
}

func (a v2) add(b v2) v2 {
	a.x += b.x
	a.y += b.y
	return a
}

func (a v2) sub(b v2) v2 {
	a.x -= b.x
	a.y -= b.y
	return a
}

func (a v2) mul(b v2) v2 {
	a.x *= b.x
	a.y *= b.y
	return a
}

func (a v2) toArray() [2]int {
	return [2]int{a.x, a.y}
}

func (a v2) div(x int) v2 {
	return v2{a.x / x, a.y / x}
}
