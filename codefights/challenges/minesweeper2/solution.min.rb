def minesweeper2 b, o, m
  e = -> x, y {
    x >= 0 &&
    y >= 0 &&
    o[x] &&
    o[x][y] == !0 &&
    (o[x][y] = !p) &&
    b[x][y] < 1 &&
    9.times {|i| e[x - 1 + i % 3, y - 1 + i / 3] }
  }

  for x, y in m
    return [] if b[x][y] > 8
    e[x, y]
  end

  o
end
