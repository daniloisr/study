def solution(xs)
  # write your code in Ruby 2.2
  left_right_sums = xs.reduce([]) { |memo, x| memo << (memo.last || 0) + x }
  right_left_sums = xs.reverse.reduce([]) { |memo, x| memo << (memo.last || 0) + x }.reverse

  (xs.size - 1).times
    .map { |i| (left_right_sums[i] - right_left_sums[i+1]).abs }
    .min
end

require 'minitest/autorun'

class TestSolution < Minitest::Test
  def test_solution
    assert 1, solution([3, 1, 2, 4, 3])
  end
end
