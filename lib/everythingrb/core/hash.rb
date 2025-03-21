# frozen_string_literal: true

#
# Extensions to Ruby's core Hash class
#
# These additions make working with hashes more convenient by adding
# conversion methods to different data structures and string formatting helpers.
#
# @example Converting to different structures
#   user = { name: "Alice", roles: ["admin"] }
#   user.to_struct    # => #<struct name="Alice", roles=["admin"]>
#   user.to_ostruct   # => #<OpenStruct name="Alice", roles=["admin"]>
#
#   # Filtering and joining hash entries
#   { a: 1, b: nil, c: 3 }.join_map(", ") { |k, v| "#{k}:#{v}" if v }
#   # => "a:1, c:3"
#
class Hash
  #
  # A minimal empty struct for Ruby 3.2+ compatibility
  #
  # Ruby 3.2 enforces stricter argument handling for Struct. This means trying to create
  # a Struct from an empty Hash will result in an ArgumentError being raised.
  # This is trying to keep a consistent experience with that version and newer versions.
  #
  # @return [Struct] A struct with a single nil-valued field
  #
  # @api private
  #
  EMPTY_STRUCT = Struct.new(:_).new(nil)

  #
  # Combines filter_map and join operations
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  #
  # @yield [key, value] Block that filters and transforms hash entries
  # @yieldparam key [Object] The current key
  # @yieldparam value [Object] The current value
  #
  # @return [String] Joined string of filtered and transformed entries
  #
  # @example
  #   { a: 1, b: nil, c: 2, d: nil, e: 3 }.join_map(", ") { |k, v| "#{k}-#{v}" if v }
  #   # => "a-1, c-2, e-3"
  #
  # @example Without a block
  #   { a: 1, b: nil, c: 2 }.join_map(" ")
  #   # => "a 1 b c 2"
  #
  def join_map(join_with = "", &block)
    block = ->(kv_pair) { kv_pair.compact } if block.nil?

    filter_map(&block).join(join_with)
  end

  #
  # Converts hash to an immutable Data structure
  #
  # @return [Data] An immutable Data object with the same structure
  #
  # @example
  #   hash = { person: { name: "Bob", age: 30 } }
  #   data = hash.to_istruct
  #   data.person.name # => "Bob"
  #   data.class # => Data
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
  # @return [Struct] A struct with methods matching hash keys
  #
  # @example
  #   hash = { user: { name: "Alice", roles: ["admin"] } }
  #   struct = hash.to_struct
  #   struct.user.name # => "Alice"
  #   struct.class # => Struct
  #
  def to_struct
    # For Ruby 3.2, it raises if you attempt to create a Struct with no keys
    return EMPTY_STRUCT if RUBY_VERSION.start_with?("3.2") && empty?

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
  # @return [OpenStruct] An OpenStruct with methods matching hash keys
  #
  # @example
  #   hash = { config: { api_key: "secret" } }
  #   config = hash.to_ostruct
  #   config.config.api_key # => "secret"
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

  #
  # Recursively freezes self and all of its values
  #
  # @return [self] Returns the frozen hash
  #
  # @example
  #   { user: { name: "Alice", roles: ["admin"] } }.deep_freeze
  #   # => Hash and all nested structures are now frozen
  #
  def deep_freeze
    each_value { |v| v.respond_to?(:deep_freeze) ? v.deep_freeze : v.freeze }
    freeze
  end
end
