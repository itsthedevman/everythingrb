# frozen_string_literal: true

#
# Extensions to Ruby's core Enumerable module
#
# These additions make working with any enumerable collection more expressive
# by combining common operations into convenient methods.
#
# @example Using join_map with a Range
#   (1..5).join_map(" | ") { |n| "item-#{n}" if n.even? }
#   # => "item-2 | item-4"
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
end
