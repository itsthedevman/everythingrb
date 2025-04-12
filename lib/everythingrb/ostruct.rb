# frozen_string_literal: true

#
# Extensions to Ruby's OpenStruct class
#
# Provides:
# - #map, #filter_map: Enumeration methods for OpenStruct entries
# - #join_map: Combine filter_map and join operations
# - #blank?, #present?: ActiveSupport integrations when available
# - #to_deep_h: Recursively convert to hash with all nested objects
#
# @example
#   require "everythingrb/ostruct"
#
#   person = OpenStruct.new(name: "Alice", age: 30)
#   person.map { |k, v| "#{k}: #{v}" }  # => ["name: Alice", "age: 30"]
#
class OpenStruct
  # ActiveSupport integrations
  if defined?(ActiveSupport)
    #
    # Checks if the OpenStruct has no attributes
    #
    # @return [Boolean] true if the OpenStruct has no attributes
    #
    def blank?
      @table.blank?
    end

    #
    # Checks if the OpenStruct has any attributes
    #
    # @return [Boolean] true if the OpenStruct has attributes
    #
    def present?
      @table.present?
    end
  end

  alias_method :each, :each_pair

  #
  # Maps over OpenStruct entries and returns an array
  #
  # @yield [key, value] Block that transforms each key-value pair
  # @yieldparam key [Symbol] The attribute name
  # @yieldparam value [Object] The attribute value
  #
  # @return [Array, Enumerator] Results of mapping or an Enumerator if no block given
  #
  # @example
  #   struct = OpenStruct.new(a: 1, b: 2)
  #   struct.map { |key, value| [key, value * 2] } # => [[:a, 2], [:b, 4]]
  #
  def map(&)
    @table.map(&)
  end

  #
  # Maps over OpenStruct entries and returns an array without nil values
  #
  # @yield [key, value] Block that transforms each key-value pair
  # @yieldparam key [Symbol] The attribute name
  # @yieldparam value [Object] The attribute value
  #
  # @return [Array, Enumerator] Non-nil results of mapping or an Enumerator if no block given
  #
  # @example
  #   struct = OpenStruct.new(a: 1, b: nil, c: 2)
  #   struct.filter_map { |key, value| value * 2 if value } # => [2, 4]
  #
  def filter_map(&block)
    return enum_for(:filter_map) unless block

    map(&block).compact
  end

  #
  # Combines filter_map and join operations
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  #
  # @yield [key, value] Block that filters and transforms OpenStruct entries
  # @yieldparam key [Symbol] The attribute name
  # @yieldparam value [Object] The attribute value
  #
  # @return [String] Joined string of filtered and transformed entries
  #
  # @example
  #   object = OpenStruct.new(a: 1, b: nil, c: 3)
  #   object.join_map(" ") { |k, v| "#{k}-#{v}" if v }
  #   # => "a-1 c-3"
  #
  # @example Default behavior without block
  #   object = OpenStruct.new(a: 1, b: nil, c: 3)
  #   object.join_map(", ")
  #   # => "a, 1, b, c, 3"
  #
  def join_map(join_with = "", &block)
    block = ->(kv_pair) { kv_pair.compact } if block.nil?

    filter_map(&block).join(join_with)
  end

  #
  # Returns self (identity method for consistent interfaces)
  #
  # @return [self] Returns the OpenStruct
  #
  def to_ostruct
    self
  end

  #
  # Recursively converts the OpenStruct and all nested objects to hashes
  #
  # @return [Hash] A deeply converted hash of the OpenStruct
  #
  # @example
  #   person = OpenStruct.new(
  #     name: "Alice",
  #     address: OpenStruct.new(city: "New York", country: "USA")
  #   )
  #   person.to_deep_h  # => {name: "Alice", address: {city: "New York", country: "USA"}}
  #
  def to_deep_h
    to_h.to_deep_h
  end
end
