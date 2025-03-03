# frozen_string_literal: true

require "test_helper"

class TestEnumerableJoinMap < Minitest::Test
  def setup
    @input = ["foo", nil, "bar", nil, "baz"].to_enum
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
      @input.join_map(", ") { |i| "#{i}!" if i }
    )
  end

  def test_it_includes_the_index
    assert_equal(
      "foo0!, bar2!, baz4!",
      @input.join_map(", ", with_index: true) { |v, i| "#{v}#{i}!" if v }
    )
  end

  def test_it_works_with_other_enumerable
    assert_equal(
      "num2 | num4 | num6 | num8 | num10",
      (1..10).join_map(" | ") { |n| "num#{n}" if n.even? }
    )
  end
end
