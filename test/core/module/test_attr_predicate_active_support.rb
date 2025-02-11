# frozen_string_literal: true

require "test_helper"

class TestModuleAttrPredicateActiveSupport < Minitest::Test
  def setup
    fail "Active support must be defined for this test" unless defined?(ActiveSupport)
  end

  def test_it_checks_presence_with_rails
    klass = Data.define(:array_1, :array_2)
    klass.attr_predicate(:array_1, :array_2)

    object = klass.new(array_1: [], array_2: [2])

    assert_equal([], object.array_1)
    assert_equal([2], object.array_2)

    refute(object.array_1?)
    assert(object.array_2?)
  end
end
