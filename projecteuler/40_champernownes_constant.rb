require 'minitest/test'
require 'byebug'

class Solution
  def self.champernowne_digit(n)
    i = 1
    loop do
      padding = i > 1 ? i*10**(i - 1) : 0
      target = i*10**i - padding
      break if n < target

      n -= target
      i += 1
    end

    base = i > 1 ? 10**(i - 1) : 0
    q, m = n.divmod(i)
    (q + base).to_s[m].to_i
  end
end

class SolutionTest < Minitest::Test
  def test_sample
    solution = 7.times.map { |i| 10**i }.map(&Solution.method(:champernowne_digit)).reduce(&:*)
    assert_equal 210, solution
  end

  def test_custom
    assert_equal 1, Solution.champernowne_digit(20)
  end
end

