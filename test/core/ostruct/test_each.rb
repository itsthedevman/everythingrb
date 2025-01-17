# frozen_string_literal: true

require "test_helper"

class TestOstructEach < Minitest::Test
  def setup
    @input = OpenStruct.new(a: 1, b: nil, c: 2)
  end

  def test_without_block
    assert_kind_of(Enumerator, @input.each)
  end

  def test_with_block
    output = []

    @input.each { |k, v| output << [k, v] if v }

    assert_equal([[:a, 1], [:c, 2]], output)
  end
end
