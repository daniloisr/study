def minesweeper2 b, o, m
  (
    x, y = m.pop
    a = b[x][y]

    9.times {|i|
      j = x - 1 + i % 3
      k = y - 1 + i / 3
      m << [j, k] if o.dig(j, k) == !1 && ~j * ~k > 0
    } if a < o[x][y] = 1

    m = o = [] if a > 8
  ) while m[0]

  o
end

