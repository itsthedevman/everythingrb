# frozen_string_literal: true

require "test_helper"

class TestOstructBlank < Minitest::Test
  def test_it_is_blank
    input = OpenStruct.new

    assert(input.blank?)
  end

  def test_it_is_not_blank
    input = OpenStruct.new(foo: "bar")

    refute(input.blank?)
  end
end
