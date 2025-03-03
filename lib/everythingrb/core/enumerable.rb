# frozen_string_literal: true

module Enumerable
  #
  # Combines filter_map and join operations
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  # @param with_index [Boolean] Whether to include the index in the block (defaults to false)
  #
  # @yield [element, index] Block that filters and transforms array elements
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
  # @example Default behavior without block
  #   [1, 2, nil, 3].join_map(", ")
  #   # => "1, 2, 3"
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
