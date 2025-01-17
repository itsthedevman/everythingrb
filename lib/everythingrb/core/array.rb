# frozen_string_literal: true

class Array
  #
  # Combines filter_map and join operations
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  #
  # @yield [Object] Block that filters and transforms array elements
  #
  # @return [String] Joined string of filtered and transformed elements
  #
  # @example
  #   [1, 2, nil, 3].join_map(" ") { |n| n&.to_s if n&.odd? }
  #   # => "1 3"
  #
  # @example
  #   [1, 2, nil, 3].join_map(", ")
  #   # => "1, 2, 3"
  #
  def join_map(join_with = "", &block)
    block = ->(i) { i } if block.nil?

    filter_map(&block).join(join_with)
  end
end
