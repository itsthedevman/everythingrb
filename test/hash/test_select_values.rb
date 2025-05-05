# frozen_string_literal: true

require "test_helper"

class TestHashSelectValues < Minitest::Test
  def setup
    @hash = {a: 1, b: 2, c: 3, d: 4}
    @block = ->(v) { v % 2 == 0 }
  end

  def test_it_selects_based_on_value
    result = @hash.select_values(&@block)

    assert_equal({b: 2, d: 4}, result)
  end

  def test_it_selects_based_on_value_in_memory
    @hash.select_values!(&@block)

    assert_equal({b: 2, d: 4}, @hash)
  end

  def test_it_filters_based_on_value
    result = @hash.filter_values(&@block)

    assert_equal({b: 2, d: 4}, result)
  end

  def test_it_filters_based_on_value_in_memory
    @hash.filter_values!(&@block)

    assert_equal({b: 2, d: 4}, @hash)
  end

  def test_it_returns_select_enum
    assert_kind_of(Enumerable, @hash.select_values)
  end

  def test_it_returns_select_enum_for_bang
    assert_kind_of(Enumerable, @hash.select_values!)
  end
end
