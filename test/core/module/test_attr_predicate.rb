# frozen_string_literal: true

require "test_helper"

class AttrPredicateMock
  attr_predicate :some_variable

  def initialize(value)
    @some_variable = value
  end
end

class TestModuleAttrPredicate < Minitest::Test
  def test_defines_the_predicate
    object = AttrPredicateMock.new(42)

    assert_equal(42, object.instance_variable_get(:@some_variable))
    assert(object.some_variable?)
  end

  def test_it_works_with_structs
    klass = Struct.new(:foo)
    klass.attr_predicate(:foo)

    object = klass.new(foo: 42)

    assert_equal(42, object.foo)
    assert(object.foo?)
  end

  def test_it_works_with_false
    klass = Data.define(:foo)
    klass.attr_predicate(:foo)

    object = klass.new(foo: false)

    assert_equal(false, object.foo)
    refute(object.foo?)
  end

  def test_it_raises_on_method_defined
    klass = Data.define(:foo) do
      def foo?
        puts "foo"
      end
    end

    binding.pry
    assert_raises(ArgumentError) { klass.attr_predicate(:foo) }
  end
end
