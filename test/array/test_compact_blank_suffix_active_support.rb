# frozen_string_literal: true

require "test_helper"

class TestArrayCompactBlankSuffix < Minitest::Test
  def test_it_removes_trailing_blanks
    result = [nil, "", "foo", 1, "", "bar", "", nil].compact_blank_suffix

    # It does not remove leading blank values
    assert_equal([nil, "", "foo", 1, "", "bar"], result)
  end

  def test_it_handles_empty_array
    assert_equal([], [].compact_blank_suffix)
  end

  def test_it_handles_single_item_array
    assert_equal([1], [1].compact_blank_suffix)
  end

  def test_it_handles_array_of_blanks
    assert_equal([], [nil, "", nil].compact_blank_suffix)
  end
end
