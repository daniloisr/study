def palindrome?(n)
  n.to_s == n.to_s.reverse
end

rs = []
for i in 0..999 do
  for j in 0..i do
    a = 999 - i
    b = 999 - j
    n = a * b
    rs << [n, a, b] if palindrome?(n)
  end
end

p rs.max { |a, b| a.first <=> b.first }
