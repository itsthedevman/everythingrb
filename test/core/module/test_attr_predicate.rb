# frozen_string_literal: true

require "test_helper"

class AttrPredicateMock
  attr_reader :some_variable
  attr_predicate :some_variable

  def initialize(value)
    @some_variable = value
  end
end

class TestModuleAttrPredicate < Minitest::Test
  def test_defines_the_predicate
    object = AttrPredicateMock.new(42)

    assert_equal(42, object.some_variable)
    assert(object.some_variable?)
  end
end
