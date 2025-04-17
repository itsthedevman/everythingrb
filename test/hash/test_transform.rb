# frozen_string_literal: true

require "test_helper"

class HashTransform < Minitest::Test
  def test_it_returns_enum_with_no_block
    assert_kind_of(Enumerator, {}.transform)
  end

  def test_it_transforms_key_and_value
    input = {a: 1, b: 2}
    result = input.transform { |k, v| [:"#{k}_key", v * 2] }

    refute_same(input, result)
    assert_equal({a_key: 2, b_key: 4}, result)
  end

  def test_it_transforms_key_and_value_in_place
    input = {a: 1, b: 2}

    result = input.transform! { |k, v| [:"#{k}_key", v * 2] }

    assert_same(input, result)
    assert_equal({a_key: 2, b_key: 4}, input)
  end
end
