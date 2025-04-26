# frozen_string_literal: true

require "test_helper"

class TestHashDeepTransformValuesWithKey < Minitest::Test
  def setup
    fail "Active support must be defined for this test" unless defined?(ActiveSupport)

    @hash = {
      key_a: 1,
      key_b: {
        key_c: 2,
        key_d: [3, 4, {key_e: 5}]
      },
      key_f: [
        {key_g: 6},
        7,
        [8, {key_h: 9}]
      ]
    }
  end

  # Checking that original functionality still works
  def test_og_transform_values
    result = @hash.deep_transform_values { |v| v * 0 }

    assert_equal(
      {
        key_a: 0,
        key_b: {
          key_c: 0,
          key_d: [0, 0, {key_e: 0}]
        },
        key_f: [
          {key_g: 0},
          0,
          [0, {key_h: 0}]
        ]
      },
      result
    )
  end

  # Checking that original functionality still works
  def test_og_deep_transform_values!
    @hash.deep_transform_values! { |v| v * 0 }

    assert_equal(
      {
        key_a: 0,
        key_b: {
          key_c: 0,
          key_d: [0, 0, {key_e: 0}]
        },
        key_f: [
          {key_g: 0},
          0,
          [0, {key_h: 0}]
        ]
      },
      @hash
    )
  end

  def test_it_returns_new_hash
    result = @hash.deep_transform_values(with_key: true) { |v, k| "#{k}#{v}" }

    assert_equal(
      {
        key_a: "key_a1",
        key_b: {
          key_c: "key_c2",
          key_d: ["3", "4", {key_e: "key_e5"}]
        },
        key_f: [
          {key_g: "key_g6"},
          "7",
          ["8", {key_h: "key_h9"}]
        ]
      },
      result
    )
  end

  def test_it_modifies_in_memory
    @hash.deep_transform_values!(with_key: true) { |v, k| "#{k}#{v}" }

    assert_equal(
      {
        key_a: "key_a1",
        key_b: {
          key_c: "key_c2",
          key_d: ["3", "4", {key_e: "key_e5"}]
        },
        key_f: [
          {key_g: "key_g6"},
          "7",
          ["8", {key_h: "key_h9"}]
        ]
      },
      @hash
    )
  end

  def test_it_returns_enum
    enum = @hash.deep_transform_values(with_key: true)
    transformed = enum.map { |v, k| "#{k}:#{v}" }

    assert_equal(
      ["key_a:1", "key_c:2", ":3", ":4", "key_e:5", "key_g:6", ":7", ":8", "key_h:9"],
      transformed
    )
  end

  def test_it_returns_enum_for_bang
    enum = @hash.deep_transform_values!(with_key: true)
    transformed = enum.map { |v, k| "#{k}:#{v}" }

    assert_equal(
      ["key_a:1", "key_c:2", ":3", ":4", "key_e:5", "key_g:6", ":7", ":8", "key_h:9"],
      transformed
    )
  end
end
