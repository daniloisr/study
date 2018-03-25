require 'byebug'
require 'minitest/autorun'

Slice = Struct.new(:sum, :count) do
  include Comparable

  def self.zero; new(0, 0); end

  def +(b)
    self.class.new(sum + b.sum, count + b.count)
  end

  def <=>(b)
    sum <=> b.sum
  end

  def nonnegative
    self >= self.class.zero
  end

  def inspect
    "(#{sum},#{count})"
  end
end

def z; Slice.zero; end

def solution(xs)
  shrink(xs.map { |x| Slice.new(x, 1) }, 0)
end

def sum(xs)
  sum, memo = xs.reduce([z, []]) do |(sum, memo), x|
    sum = sum + x
    sum > z ?
      [sum, memo] :
      [z,   memo + [sum]]
  end

  memo + (sum > z ? [sum] : [])
end

def shrink(xs, i, shrank = false)
  xs = sum(xs)
  a, b = xs[i], xs[i+1]

  p [i, shrank, xs]

  case
  when b.nil? && shrank then shrink(xs, 0)
  when b.nil?           then xs.lazy.select(&:nonnegative).map(&:count).max || z
  when a + b > z        then shrink(xs[0...i] + [a + b] + xs[i+2..-1], i > 0 ? i - 1 : i, true)
  when a + b == z       then [shrink(xs[0...i] + [a + b] + xs[i+2..-1], i, true), shrink(xs, i + 1, shrank)].max
  else                       shrink(xs, i + 1, shrank)
  end
end

class TestSolution < Minitest::Test
  def test_sample1
    assert_equal 7, solution([-1, -1, 1, -1, 1, 0, 1, -1, -1])
  end

  def test_sample2
    assert_equal 4, solution([1, 1, -1, -1, -1, -1, -1, 1, 1])
  end

  def test_sample_abc
    assert_equal 20, solution([*[1]*5, *[-1]*10, *[1]*5])
  end

  def test_custom0
    assert_equal 0, solution([-1, -1])
  end

  def test_custom1
    assert_equal 1, solution([0, -1])
  end

  def test_custom2
    assert_equal 2, solution([1, -1])
  end

  def test_tricky1
    assert_equal 4, solution([-1, 1, -1, -1, 1])
  end

  def test_tricky2
    assert_equal 1, solution([-1, 0, -1, -1, 0])
  end
end

