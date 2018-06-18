def solution(a, b)
  x, y = a.first, b.first
  i, s = 1, a.size
  r = 0

  while i < s do
    next (x, y, i, r = a[i], b[i], i + 1, r    ) if x < a[i] && y < b[i]
    next (x, y, i, r = b[i], a[i], i + 1, [r + 1, i - r + 1].min) if x < b[i] && y < a[i]
    return -1
  end
  [r, s - r].min
end

require 'minitest/autorun'
require 'byebug'

class SolutionTest < Minitest::Test
  def test_sample1
    a = [5, 3, 7, 7, 10]
    b = [1, 6, 6, 9, 9]
    assert_equal 2, solution(a, b)
  end

  def test_sample2
    a = [5, -3, 6, 4, 8]
    b = [2, 6, -5, 1, 0]
    assert_equal -1, solution(a, b)
  end

  def test_sample3
    a = [1, 5, 6]
    b = [-2, 0, 2]
    assert_equal 0, solution(a, b)
  end

  def test_custom1
    a = [3, 2]
    b = [1, 4]
    assert_equal 1, solution(a, b)
  end

  def test_custom2_change_at_0
    a = [3, 2, 3]
    b = [1, 4, 5]
    assert_equal 1, solution(a, b)
  end

  def test_custom3_change_at_0_alt
    a = [1, 4, 5]
    b = [3, 2, 3]
    assert_equal 1, solution(a, b)
  end

  def test_custom3_1_change_at_middle
    a = [1, 4, 3]
    b = [3, 2, 5]
    assert_equal 1, solution(a, b)
  end

  def test_custom4_change_at_tail
    a = [1, 2, 5]
    b = [3, 4, 3]
    assert_equal 1, solution(a, b)
  end

  def test_custom5
    a = [1, 2, 2, 4, 4, 6, 6]
    b = [0, 1, 3, 3, 5, 5, 7]
    assert_equal 3, solution(a, b)
  end

  def test_changes_two
    a = [1, 2, 9, 10]
    b = [7, 8, 3, 4]
    assert_equal 2, solution(a, b)
  end

  def test_changes_two_b
    a = [7, 8, 3, 4]
    b = [1, 2, 9, 10]
    assert_equal 2, solution(a, b)
  end

  def test_changes_three
    a = [1, 2, 9, 10, 11]
    b = [7, 8, 3, 4, 5]
    assert_equal 2, solution(a, b)
  end

  def test_changes_no_pair
    a = [1, 8, 3, 10, 5]
    b = [7, 2, 9, 4, 11]
    assert_equal 2, solution(a, b)
  end

  def test_changes_no_pair
    a = [0, 1, 10, 10, 15]
    b = [1, 5, 2, 30, 50]
    assert_equal 1, solution(a, b)
  end

  def test_tricky
    a = [0, 9, 5, 7]
    b = [0, 4, 10, 11]
    assert_equal 1, solution(a, b)
  end
end
