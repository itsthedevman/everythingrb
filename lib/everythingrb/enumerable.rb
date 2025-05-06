# frozen_string_literal: true

#
# Extensions to Ruby's core Enumerable module
#
# Provides:
# - #join_map: Combine filter_map and join operations into one step
# - #group_by_key: Group elements by key or nested keys, simplifying collection organization
#
# @example
#   require "everythingrb/enumerable"
#   (1..5).join_map(" | ") { |n| "item-#{n}" if n.even? }  # => "item-2 | item-4"
#   users.group_by_key(:role)  # Groups users by their role
#
module Enumerable
  #
  # Combines filter_map and join operations
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  # @param with_index [Boolean] Whether to include the index in the block (defaults to false)
  #
  # @yield [element, index] Block that filters and transforms elements
  # @yieldparam element [Object] The current element
  # @yieldparam index [Integer] The index of the current element (only if with_index: true)
  #
  # @return [String] Joined string of filtered and transformed elements
  # @return [Enumerator] If no block is given
  #
  # @example Without index
  #   [1, 2, nil, 3].join_map(" ") { |n| n&.to_s if n&.odd? }
  #   # => "1 3"
  #
  # @example With index
  #   ["a", "b", "c"].join_map(", ", with_index: true) { |char, i| "#{i}:#{char}" }
  #   # => "0:a, 1:b, 2:c"
  #
  # @example Using with other enumerables
  #   (1..10).join_map(" | ") { |n| "num#{n}" if n.even? }
  #   # => "num2 | num4 | num6 | num8 | num10"
  #
  def join_map(join_with = "", with_index: false, &block)
    block = ->(i) { i } if block.nil?

    if with_index
      filter_map.with_index(&block).join(join_with)
    else
      filter_map(&block).join(join_with)
    end
  end

  #
  # Groups elements by a given key or nested keys
  #
  # @param keys [Array<Symbol, String>] The key(s) to group by
  #
  # @yield [value] Optional block to transform the key value before grouping
  # @yieldparam value [Object] The value at the specified key(s)
  # @yieldreturn [Object] The transformed value to use as the group key
  #
  # @return [Hash] A hash where keys are the grouped values and values are arrays of elements
  # @return [Enumerator] If no block is given
  #
  # @example Group by a single key
  #   users = [
  #     {name: "Alice", role: "admin"},
  #     {name: "Bob", role: "user"},
  #     {name: "Charlie", role: "admin"}
  #   ]
  #   users.group_by_key(:role)
  #   # => {"admin"=>[{name: "Alice", role: "admin"}, {name: "Charlie", role: "admin"}],
  #   #     "user"=>[{name: "Bob", role: "user"}]}
  #
  # @example Group by nested keys
  #   data = [
  #     {department: {name: "Sales"}, employee: "Alice"},
  #     {department: {name: "IT"}, employee: "Bob"},
  #     {department: {name: "Sales"}, employee: "Charlie"}
  #   ]
  #   data.group_by_key(:department, :name)
  #   # => {"Sales"=>[{department: {name: "Sales"}, employee: "Alice"},
  #   #                {department: {name: "Sales"}, employee: "Charlie"}],
  #   #     "IT"=>[{department: {name: "IT"}, employee: "Bob"}]}
  #
  # @example With transformation block
  #   users.group_by_key(:role) { |role| role.upcase }
  #   # => {"ADMIN"=>[{name: "Alice", role: "admin"}, {name: "Charlie", role: "admin"}],
  #   #     "USER"=>[{name: "Bob", role: "user"}]}
  #
  def group_by_key(*keys, &block)
    group_by do |value|
      result = value.respond_to?(:dig) ? value.dig(*keys) : nil
      result = yield(result) if block
      result
    end
  end
end
