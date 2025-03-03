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

  #
  # Maps over hash keys to extract values for a specific key
  #
  # @param key [Symbol, String] The key to extract
  #
  # @return [Array] Array of values
  #
  # @example
  #   [{name: 'Alice', age: 30}, {name: 'Bob', age: 25}].key_map(:name)
  #   # => ['Alice', 'Bob']
  #
  def key_map(key)
    map { |v| v[key] }
  end

  #
  # Maps over hash keys to extract nested values using dig
  #
  # @param keys [Array<Symbol, String>] The keys to dig through
  #
  # @return [Array] Array of nested values
  #
  # @example
  #   [
  #     {user: {profile: {name: 'Alice'}}},
  #     {user: {profile: {name: 'Bob'}}}
  #   ].dig_map(:user, :profile, :name)
  #   # => ['Alice', 'Bob']
  #
  def dig_map(*keys)
    map { |v| v.dig(*keys) }
  end
end
