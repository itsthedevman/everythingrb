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

    assert_raises(ArgumentError) { klass.attr_predicate(:foo) }
  end

  def test_from_with_ivar_source
    klass = Class.new do
      attr_accessor :started_at
      attr_predicate :started, from: :@started_at
    end

    object = klass.new
    refute(object.started?)

    object.started_at = Time.now
    assert(object.started?)
  end

  def test_from_with_method_source
    klass = Class.new do
      attr_accessor :error_messages
      attr_predicate :errored, from: :error_messages
    end

    object = klass.new
    refute(object.errored?)

    object.error_messages = ["Something went wrong"]
    assert(object.errored?)
  end

  def test_from_with_undefined_ivar_returns_false
    klass = Class.new do
      attr_predicate :started, from: :@started_at
    end

    object = klass.new
    refute(object.started?)
  end

  def test_from_with_missing_method_raises_error
    klass = Class.new do
      attr_predicate :errored, from: :error_messages
    end

    object = klass.new
    assert_raises(NoMethodError) { object.errored? }
  end

  def test_from_with_multiple_attributes_raises_error
    klass = Class.new

    error = assert_raises(ArgumentError) do
      klass.attr_predicate(:started, :finished, from: :@started_at)
    end

    assert_match(/cannot use from: option with multiple attributes/i, error.message)
  end

  def test_private_option
    klass = Class.new do
      attr_accessor :verified
      attr_predicate :verified, private: true
    end

    object = klass.new
    object.verified = true

    refute(object.respond_to?(:verified?))
    assert(object.respond_to?(:verified?, true))
    assert(object.send(:verified?))
  end

  def test_private_with_from
    klass = Class.new do
      attr_accessor :verified_at
      attr_predicate :verified, from: :@verified_at, private: true
    end

    object = klass.new
    object.verified_at = Time.now

    refute(object.respond_to?(:verified?))
    assert(object.send(:verified?))
  end

  def test_empty_array_returns_false
    klass = Class.new do
      attr_accessor :errors
      attr_predicate :errors
    end

    object = klass.new
    object.errors = []

    refute(object.errors?)
  end

  def test_non_empty_array_returns_true
    klass = Class.new do
      attr_accessor :errors
      attr_predicate :errors
    end

    object = klass.new
    object.errors = ["something went wrong"]

    assert(object.errors?)
  end

  def test_empty_hash_returns_false
    klass = Class.new do
      attr_accessor :metadata
      attr_predicate :metadata
    end

    object = klass.new
    object.metadata = {}

    refute(object.metadata?)
  end

  def test_non_empty_hash_returns_true
    klass = Class.new do
      attr_accessor :metadata
      attr_predicate :metadata
    end

    object = klass.new
    object.metadata = {key: "value"}

    assert(object.metadata?)
  end

  def test_empty_string_returns_false
    klass = Class.new do
      attr_accessor :name
      attr_predicate :name
    end

    object = klass.new
    object.name = ""

    refute(object.name?)
  end

  def test_non_empty_string_returns_true
    klass = Class.new do
      attr_accessor :name
      attr_predicate :name
    end

    object = klass.new
    object.name = "Alice"

    assert(object.name?)
  end
end
