# frozen_string_literal: true

require "test_helper"

class TestHashCompactBlankMerge < Minitest::Test
  def setup
    fail "Active support must be defined for this test" unless defined?(ActiveSupport)

    @hash = {name: "Alice", role: "admin"}
  end

  def test_it_merges_only_present_values
    input = {
      bio: "",                  # blank string - excluded
      tags: [],                 # empty array - excluded
      email: "a@example.com",   # present - included
      phone: nil,               # nil - excluded
      active: true,             # present - included
      score: 0                  # present (0 is not blank) - included
    }

    result = @hash.compact_blank_merge(input)

    assert_equal(
      {
        name: "Alice",
        role: "admin",
        email: "a@example.com",
        active: true,
        score: 0
      },
      result
    )
  end

  def test_it_merges_only_present_values_in_place
    input = {
      bio: "",                  # blank string - excluded
      tags: [],                 # empty array - excluded
      email: "a@example.com",   # present - included
      phone: nil,               # nil - excluded
      active: true              # present - included
    }

    @hash.compact_blank_merge!(input)

    assert_equal(
      {
        name: "Alice",
        role: "admin",
        email: "a@example.com",
        active: true
      },
      @hash
    )
  end

  def test_it_works_with_kwargs
    result = @hash.compact_blank_merge(
      bio: "",
      email: "test@example.com",
      tags: []
    )

    assert_equal(
      {
        name: "Alice",
        role: "admin",
        email: "test@example.com"
      },
      result
    )
  end

  def test_it_handles_empty_hash_merge
    result = @hash.compact_blank_merge({})
    assert_equal(@hash, result)
    refute_same(@hash, result)
  end

  def test_it_handles_all_blank_values
    result = @hash.compact_blank_merge(
      empty_string: "",
      empty_array: [],
      nil_value: nil,
      whitespace: "   "
    )

    assert_equal(@hash, result)
  end
end
