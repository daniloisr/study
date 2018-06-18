sum_squares = (1..100).reduce(0) { |sum, i| sum + i * i }
square_of_sum = (101 * 100 / 2)**2
puts square_of_sum - sum_squares
