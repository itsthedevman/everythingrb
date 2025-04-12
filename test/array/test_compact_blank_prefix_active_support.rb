# frozen_string_literal: true

require "test_helper"

class TestArrayCompactBlankPrefix < Minitest::Test
  def test_it_removes_leading_blanks
    result = [nil, "", "foo", 1, "", "bar", "", nil].compact_blank_prefix

    # It does not remove trailing blank values
    assert_equal(["foo", 1, "", "bar", "", nil], result)
  end

  def test_it_handles_empty_array
    assert_equal([], [].compact_blank_prefix)
  end

  def test_it_handles_single_item_array
    assert_equal([1], [1].compact_blank_prefix)
  end

  def test_it_handles_array_of_blanks
    assert_equal([], [nil, "", nil].compact_blank_prefix)
  end
end
