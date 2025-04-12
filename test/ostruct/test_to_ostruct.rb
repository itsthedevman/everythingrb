# frozen_string_literal: true

require "test_helper"

class TestOstructToOstruct < Minitest::Test
  def test
    input = OpenStruct.new(foo: 1)

    assert_kind_of(OpenStruct, input.to_ostruct)
    assert_equal(input, input.to_ostruct)
  end
end
