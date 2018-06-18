def fibs
  Enumerator.new do |y|
    a, b = 0, 1
    loop do
      a, b = b, a + b
      y << b
    end
  end
end

puts fibs.lazy
  .take_while { |i| i < 4e6 }
  .select(&:even?)
  .tap { |i| p i.to_a }
  .sum

