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
end
