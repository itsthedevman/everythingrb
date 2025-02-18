# frozen_string_literal: true

class Hash
  #
  # Combines filter_map and join operations
  #
  # @see Array#join_map
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  #
  # @yield [Object] Block that filters and transforms hash values
  #
  # @return [String] Joined string of filtered and transformed values
  #
  # @example
  #   { a: 1, b: 2, c: nil, d: 3 }.join_map(" ") { |v| v&.to_s if v&.odd? }
  #   # => "1 3"
  #
  # @example
  #   { a: 1, b: 2, c: nil, d: 3 }.join_map(", ")
  #   # => "a, 2, b, 2, c, d, 3"
  #
  def join_map(join_with = "", &block)
    block = ->(kv_pair) { kv_pair.compact } if block.nil?

    filter_map(&block).join(join_with)
  end

  #
  # Converts hash to an immutable Data structure
  #
  # @return [Data]
  #
  def to_istruct
    recurse = lambda do |input|
      case input
      when Hash
        input.to_istruct
      when Array
        input.map(&recurse)
      else
        input
      end
    end

    Data.define(*keys.map(&:to_sym)).new(*values.map { |value| recurse.call(value) })
  end

  #
  # Converts hash to a Struct recursively
  #
  # @return [Struct]
  #
  def to_struct
    recurse = lambda do |value|
      case value
      when Hash
        value.to_struct
      when Array
        value.map(&recurse)
      else
        value
      end
    end

    Struct.new(*keys.map(&:to_sym)).new(*values.map { |value| recurse.call(value) })
  end

  #
  # Converts hash to an OpenStruct recursively
  #
  # @return [OpenStruct]
  #
  def to_ostruct
    recurse = lambda do |value|
      case value
      when Hash
        value.to_ostruct
      when Array
        value.map(&recurse)
      else
        value
      end
    end

    OpenStruct.new(**transform_values { |value| recurse.call(value) })
  end
end
