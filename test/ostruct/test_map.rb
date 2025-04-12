# frozen_string_literal: true

require "test_helper"

class TestOstructMap < Minitest::Test
  def setup
    @input = OpenStruct.new(a: 1, b: nil, c: 2)
  end

  def test_without_block
    assert_kind_of(Enumerator, @input.map)
  end

  def test_with_block
    output = @input.map { |k, v| [v, k] }

    assert_equal([[1, :a], [nil, :b], [2, :c]], output)
  end
end
