lines = [
  [1, 2, 3, 0],
  [3, 4, 1, 2],
  [2, 3, 4, 1],
  [4, 1, 2, 3]
]

dim = 4
b_dim = 2
targets = (1..dim).to_a

blocks = Array.new(dim) do |k|
  b_dim.times.flat_map do |i|
    i += k / b_dim * b_dim
    padding = (k % b_dim) * b_dim
    Array.new(b_dim) { |j| lines[i][padding + j] }
  end
end

p blocks
