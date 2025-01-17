# frozen_string_literal: true

class Array
  #
  # Enhances Array class with a join_map method that combines filter_map and join operations.
  # Performs a join if no block is provided
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  # @yield [Object] Block that filters and transforms array elements
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
    return compact.join(join_with) if block.nil?

    filter_map(&block).join(join_with)
  end
end
