# frozen_string_literal: true

require "test_helper"

class TestOstructPresent < Minitest::Test
  def setup
    fail "Active support must be defined for this test" unless defined?(ActiveSupport)
  end

  def test_it_is_present
    input = OpenStruct.new(foo: "bar")

    assert(input.present?)
  end

  def test_it_is_not_present
    input = OpenStruct.new

    refute(input.present?)
  end
end
