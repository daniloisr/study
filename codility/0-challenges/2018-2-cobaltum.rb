# you can write to stdout for debugging purposes, e.g.
# puts "this is a debug message"

def solution(a, b)
  # write your code in Ruby 2.2
  result = 0
  s = a.size
  i = 0

  while i < s - 1 do
    j = i + 1

    # last pair to check
    if j == s - 1
      # no swap needed
      if a[i] < a[j] && b[i] < b[j]
        next i += 1
      end
      # try swaping j
      if a[i] < b[j] && b[i] < a[j] || b[i] < a[j] && a[i] < b[j]
        result += 1
        next i += 1
      end
      # imposible to swap
      return -1
    end

    k = j + 1
    next i += 1 if a[i] < a[j] && a[j] < a[k] &&
                   b[i] < b[j] && b[j] < b[k]

    # try to swap j
    valid_swap_j = a[i] < b[j] && b[j] < a[k] &&
                   b[i] < a[j] && a[j] < b[k]
    if valid_swap_j
      a[j], b[j] = b[j], a[j]
      result += 1
      next i += 1
    end

    # try to swap k
    valid_swap_k = a[i] < a[j] && a[j] < b[k] &&
                   b[i] < b[j] && b[j] < a[k]
    if valid_swap_k
      a[k], b[k] = b[k], a[k]
      result += 1
      next i += 1
    end

    # finaly swaps i
    if a[i] < b[j] && b[i] < a[j]
      a[i], b[i] = b[i], a[i]
      result += 1
      next i += 1
    end

    # imposible to swap
    return -1
  end

  [result, s - result].min
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
end
