# frozen_string_literal: true

require "test_helper"

class TestArrayTrimNils < Minitest::Test
  def test_it_removes_leading_and_trailing_nils
    result = [nil, nil, "", nil, 1, nil, nil, nil].trim_nils

    # It does not remove blank values
    assert_equal(["", nil, 1], result)
  end

  def test_it_handles_empty_array
    assert_equal([], [].trim_nils)
  end

  def test_it_handles_single_item_array
    assert_equal([1], [1].trim_nils)
  end

  def test_it_handles_array_of_nils
    assert_equal([], [nil, nil, nil].compact_prefix)
  end
end
