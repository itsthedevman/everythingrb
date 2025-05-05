# frozen_string_literal: true

require "test_helper"

class TestHashRejectValues < Minitest::Test
  def setup
    @hash = {a: 1, b: 2, c: 3, d: 4}
    @block = ->(v) { v % 2 == 0 }
  end

  def test_it_rejects_based_on_value
    result = @hash.reject_values(&@block)

    assert_equal({a: 1, c: 3}, result)
  end

  def test_it_rejects_based_on_value_in_memory
    @hash.reject_values!(&@block)

    assert_equal({a: 1, c: 3}, @hash)
  end

  def test_it_returns_enum
    assert_kind_of(Enumerable, @hash.reject_values)
  end

  def test_it_returns_enum_for_bang
    assert_kind_of(Enumerable, @hash.reject_values!)
  end
end
