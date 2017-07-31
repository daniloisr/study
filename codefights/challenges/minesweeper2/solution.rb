def minesweeper2(gameboard, opening, moves)
  moves.each do |(x, y)|
    next if opening[x][y]
    break opening = [] if gameboard[x][y] == 9
    next opening[x][y] = true if gameboard[x][y] > 0

    expand = lambda do |x, y|
      return if x < 0 || x >= gameboard.size
      return if y < 0 || y >= gameboard.first.size
      return if opening[x][y]

      opening[x][y] = true

      return if gameboard[x][y] != 0

      expand.call(x - 1, y - 1)
      expand.call(x - 1, y - 0)
      expand.call(x - 1, y + 1)

      expand.call(x - 0, y - 1)
      expand.call(x - 0, y + 1)

      expand.call(x + 1, y - 1)
      expand.call(x + 1, y - 0)
      expand.call(x + 1, y + 1)
    end

    expand.call(x, y)
  end
  opening
end
