# frozen_string_literal: true

require "test_helper"

class TestArrayCompactSuffix < Minitest::Test
  def test_it_removes_trailing_nils
    result = [nil, nil, "", nil, 1, nil, nil, nil].compact_suffix

    # It does not remove leading nils or blank values
    assert_equal([nil, nil, "", nil, 1], result)
  end

  def test_it_handles_empty_array
    assert_equal([], [].compact_suffix)
  end

  def test_it_handles_single_item_array
    assert_equal([1], [1].compact_suffix)
  end

  def test_it_handles_array_of_nils
    assert_equal([], [nil, nil, nil].compact_suffix)
  end
end
