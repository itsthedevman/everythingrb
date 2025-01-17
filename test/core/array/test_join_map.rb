# frozen_string_literal: true

require "test_helper"

class TestArrayJoinMap < Minitest::Test
  def setup
    @input = ["foo", "bar", "baz"]
  end

  def test_it_joins_without_block
    assert_equal(
      "foo bar baz",
      @input.join_map(" ")
    )
  end

  def test_it_joins_with_block
    assert_equal(
      "foo!, bar!, baz!",
      @input.join_map(", ") { |i| "#{i}!" }
    )
  end
end
