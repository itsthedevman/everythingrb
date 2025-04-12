# frozen_string_literal: true

require "test_helper"

class TestArrayTrimBlanks < Minitest::Test
  def test_it_removes_leading_and_trailing_blanks
    result = [nil, "", "foo", 1, "", "bar", "", nil].trim_blanks

    # It does not remove inner blank values
    assert_equal(["foo", 1, "", "bar"], result)
  end

  def test_it_handles_empty_array
    assert_equal([], [].trim_blanks)
  end

  def test_it_handles_single_item_array
    assert_equal([1], [1].trim_blanks)
  end

  def test_it_handles_array_of_blanks
    assert_equal([], [nil, "", nil].trim_blanks)
  end
end
