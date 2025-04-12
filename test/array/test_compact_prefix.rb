# frozen_string_literal: true

require "test_helper"

class TestArrayCompactPrefix < Minitest::Test
  def test_it_removes_leading_nils
    result = [nil, nil, "", nil, 1, nil, nil, nil].compact_prefix

    # It does not remove trailing nils or blank values
    assert_equal(["", nil, 1, nil, nil, nil], result)
  end

  def test_it_handles_empty_array
    assert_equal([], [].compact_prefix)
  end

  def test_it_handles_single_item_array
    assert_equal([1], [1].compact_prefix)
  end

  def test_it_handles_array_of_nils
    assert_equal([], [nil, nil, nil].compact_prefix)
  end
end
