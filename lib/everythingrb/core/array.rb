# frozen_string_literal: true

#
# Extensions to Ruby's core Array class
#
# This module adds convenient mapping, joining, and freezing functionality
# to all Arrays in your application.
#
# @example Using the extensions
#   numbers = [1, 2, nil, 3]
#
#   # Filter out nils and format odd numbers
#   numbers.join_map(", ") { |n| "odd: #{n}" if n&.odd? }
#   # => "odd: 1, odd: 3"
#
#   users = [{name: "Alice", role: "admin"}, {name: "Bob", role: "user"}]
#   users.key_map(:name)    # => ["Alice", "Bob"]
#
class Array
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

  #
  # Maps over hash keys to extract values for a specific key
  #
  # @param key [Symbol, String] The key to extract
  #
  # @return [Array] Array of values extracted from each hash
  #
  # @example
  #   [{name: "Alice", age: 30}, {name: "Bob", age: 25}].key_map(:name)
  #   # => ["Alice", "Bob"]
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
  #     {user: {profile: {name: "Alice"}}},
  #     {user: {profile: {name: "Bob"}}}
  #   ].dig_map(:user, :profile, :name)
  #   # => ["Alice", "Bob"]
  #
  def dig_map(*keys)
    map { |v| v.dig(*keys) }
  end

  #
  # Recursively freezes self and all of its contents
  #
  # @return [self] Returns the frozen array
  #
  # @example Freeze an array with nested structures
  #   ["hello", { name: "Alice" }, [1, 2, 3]].deep_freeze
  #   # => All elements and nested structures are now frozen
  #
  def deep_freeze
    each { |v| v.respond_to?(:deep_freeze) ? v.deep_freeze : v.freeze }
    freeze
  end

  #
  # Removes nil values from the beginning of an array
  #
  # @return [Array] Array with leading nil values removed
  #
  # @example
  #   [nil, nil, 1, 2, nil, 3].compact_prefix
  #   # => [1, 2, nil, 3]
  #
  def compact_prefix
    drop_while(&:nil?)
  end

  #
  # Removes nil values from the end of an array
  #
  # @return [Array] Array with trailing nil values removed
  #
  # @example
  #   [1, 2, nil, 3, nil, nil].compact_suffix
  #   # => [1, 2, nil, 3]
  #
  def compact_suffix
    reverse.drop_while(&:nil?).reverse
  end

  #
  # Removes nil values from both the beginning and end of an array
  #
  # @return [Array] Array with leading and trailing nil values removed
  #
  # @example
  #   [nil, nil, 1, 2, nil, 3, nil, nil].trim_nils
  #   # => [1, 2, nil, 3]
  #
  def trim_nils
    compact_prefix.compact_suffix
  end

  # ActiveSupport integrations
  if defined?(ActiveSupport)
    #
    # Removes blank values from the beginning of an array
    #
    # @return [Array] Array with leading blank values removed
    #
    # @example With ActiveSupport loaded
    #   [nil, "", 1, 2, "", 3].compact_blank_prefix
    #   # => [1, 2, "", 3]
    #
    def compact_blank_prefix
      drop_while(&:blank?)
    end

    #
    # Removes blank values from the end of an array
    #
    # @return [Array] Array with trailing blank values removed
    #
    # @example With ActiveSupport loaded
    #   [1, 2, "", 3, nil, ""].compact_blank_suffix
    #   # => [1, 2, "", 3]
    #
    def compact_blank_suffix
      reverse.drop_while(&:blank?).reverse
    end

    #
    # Removes blank values from both the beginning and end of an array
    #
    # @return [Array] Array with leading and trailing blank values removed
    #
    # @example With ActiveSupport loaded
    #   [nil, "", 1, 2, "", 3, nil, ""].trim_blanks
    #   # => [1, 2, "", 3]
    #
    def trim_blanks
      compact_blank_prefix.compact_blank_suffix
    end

    #
    # Joins array elements into a sentence with "or" connector
    #
    # Similar to ActiveSupport's #to_sentence but uses "or" instead of "and"
    # as the joining word between elements.
    #
    # @param options [Hash] Options to pass to #to_sentence
    #
    # @return [String] Array elements joined in sentence form with "or" connector
    #
    # @example Basic usage
    #   ["red", "blue", "green"].to_or_sentence
    #   # => "red, blue, or green"
    #
    # @example With only two elements
    #   ["yes", "no"].to_or_sentence
    #   # => "yes or no"
    #
    def to_or_sentence(options = {})
      options = options.reverse_merge(last_word_connector: ", or ", two_words_connector: " or ")
      to_sentence(options)
    end
  end
end
