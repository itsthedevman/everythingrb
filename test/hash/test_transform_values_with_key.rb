# frozen_string_literal: true

require "test_helper"

class TestHashTransformValuesWithKey < Minitest::Test
  def setup
    @hash = {key_1: 1, key_2: 2}
  end

  # Checking that original functionality still works
  def test_og_transform_values
    result = @hash.transform_values { |v| v * 0 }
    assert_equal({key_1: 0, key_2: 0}, result)
  end

  # Checking that original functionality still works
  def test_og_transform_values!
    @hash.transform_values! { |v| v * 0 }
    assert_equal({key_1: 0, key_2: 0}, @hash)
  end

  def test_it_returns_new_hash
    result = @hash.transform_values(with_key: true) { |v, k| "#{k}#{v}" }

    assert_equal({key_1: "key_11", key_2: "key_22"}, result)
  end

  def test_it_modifies_in_memory
    @hash.transform_values!(with_key: true) { |v, k| "#{k}#{v}" }

    assert_equal({key_1: "key_11", key_2: "key_22"}, @hash)
  end

  def test_it_returns_enum
    enum = @hash.transform_values(with_key: true)
    transformed = enum.map { |v, k| "#{k}:#{v}" }

    assert_equal(["key_1:1", "key_2:2"], transformed)
  end

  def test_it_returns_enum_for_bang
    enum = @hash.transform_values!(with_key: true)
    transformed = enum.map { |v, k| "#{k}:#{v}" }

    assert_equal(["key_1:1", "key_2:2"], transformed)
  end
end
