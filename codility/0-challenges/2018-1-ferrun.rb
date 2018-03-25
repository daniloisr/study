require 'byebug'
require 'minitest/autorun'

def solution(xs)
  prefix = {}
  sum = 0

  xs.each_with_index.reduce(0) do |slice, (x, i)|
    sum += x

    next i + 1 if sum >= 0
    next [slice, i - prefix[sum]].max if prefix.key?(sum)
    prefix[sum] = i
    slice
  end
end

class TestSolution < Minitest::Test
  def test_sample1
    assert_equal 7, solution([-1, -1, 1, -1, 1, 0, 1, -1, -1])
  end

  def test_sample2
    assert_equal 4, solution([1, 1, -1, -1, -1, -1, -1, 1, 1])
  end

  def test_sample3
    assert_equal 5, solution([0, -1, 0, 1, 0, -1])
    # assert_equal 6, solution([0, -1, 0, 0, 1, 0, -1, -1])
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

  def test_custom3
    assert_equal 3, solution([1, -1, 0])
    assert_equal 2, solution([1, -1, -1])
    assert_equal 1, solution([0, -1, -1])
    assert_equal 0, solution([-1, -1, -1])
  end

  def test_tricky1
    assert_equal 4, solution([-1, 1, -1, -1, 1])
  end

  def test_tricky2
    assert_equal 1, solution([-1, 0, -1, -1, 0])
  end
end

