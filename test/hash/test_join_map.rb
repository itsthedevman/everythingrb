# frozen_string_literal: true

require "test_helper"

class TestHashJoinMap < Minitest::Test
  def setup
    @input = {
      a: 1,
      b: nil,
      c: 2,
      d: nil,
      e: 3
    }
  end

  def test_it_joins_without_block
    assert_equal(
      "a 1 b c 2 d e 3",
      @input.join_map(" ")
    )
  end

  def test_it_joins_with_block
    assert_equal(
      "a-1, c-2, e-3",
      @input.join_map(", ") { |k, v| "#{k}-#{v}" if v }
    )
  end

  def test_it_includes_the_index
    assert_equal(
      "a0, c2, e4",
      @input.join_map(", ", with_index: true) { |(k, v), i| "#{k}#{i}" if v }
    )
  end

  def test_it_works_with_destructuring
    users = {alice: "Alice", bob: "Bob", charlie: "Charlie"}

    assert_equal(
      "1. Alice, 2. Bob, 3. Charlie",
      users.join_map(", ", with_index: true) { |(k, v), i| "#{i + 1}. #{v}" }
    )
  end

  def test_index_tracks_all_entries_not_just_yielded_ones
    # Index should increment for all entries, not just the ones that pass the filter
    result = @input.join_map(" | ", with_index: true) { |(k, v), i| "#{k}#{i}" if v }

    # Indices should be 0, 2, 4 (for positions of a:1, c:2, e:3 in the original hash)
    assert_equal("a0 | c2 | e4", result)
  end
end
