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

  # Needed below
  alias_method :og_transform_values, :transform_values
  alias_method :og_transform_values!, :transform_values!

  #
  # Transforms hash values while allowing access to keys via the chainable with_key method
  #
  # This method either performs a standard transform_values operation if a block is given,
  # or returns an enumerator with a with_key method that passes both the key and value
  # to the block.
  #
  # @yield [value] Block to transform each value (standard behavior)
  # @yieldparam value [Object] The value to transform
  # @yieldreturn [Object] The transformed value
  #
  # @return [Hash, Enumerator] Result hash or Enumerator with with_key method
  #
  # @example Standard transform_values
  #   {a: 1, b: 2}.transform_values { |v| v * 2 }
  #   # => {a: 2, b: 4}
  #
  # @example Using with_key to access keys during transformation
  #   {a: 1, b: 2}.transform_values.with_key { |k, v| "#{k}_#{v}" }
  #   # => {a: "a_1", b: "b_2"}
  #
  def transform_values(&block)
    return transform_values_enumerator if block.nil?

    og_transform_values(&block)
  end

  #
  # Transforms hash values in place while allowing access to keys via the chainable with_key method
  #
  # This method either performs a standard transform_values! operation if a block is given,
  # or returns an enumerator with a with_key method that passes both the key and value
  # to the block, updating the hash in place.
  #
  # @yield [value] Block to transform each value (standard behavior)
  # @yieldparam value [Object] The value to transform
  # @yieldreturn [Object] The transformed value
  #
  # @return [self, Enumerator]
  #   Original hash with transformed values or Enumerator with with_key method
  #
  # @example Standard transform_values!
  #   hash = {a: 1, b: 2}
  #   hash.transform_values! { |v| v * 2 }
  #   # => {a: 2, b: 4}
  #
  # @example Using with_key to access keys during in-place transformation
  #   hash = {a: 1, b: 2}
  #   hash.transform_values!.with_key { |k, v| "#{k}_#{v}" }
  #   # => {a: "a_1", b: "b_2"}
  #
  def transform_values!(&block)
    return transform_values_bang_enumerator if block.nil?

    og_transform_values!(&block)
  end

  private

  def transform_values_enumerator
    original_hash = self
    enum = to_enum(:transform_values)

    # Add the with_key method directly to the enum
    enum.define_singleton_method(:with_key) do |&block|
      raise ArgumentError, "Missing block for Hash#transform_values.with_key" if block.nil?

      original_hash.each_pair.with_object({}) do |(key, value), output|
        output[key] = block.call(key, value)
      end
    end

    enum
  end

  def transform_values_bang_enumerator
    original_hash = self
    enum = to_enum(:transform_values!)

    # Add the with_key method directly to the enum
    enum.define_singleton_method(:with_key) do |&block|
      raise ArgumentError, "Missing block for Hash#transform_values!.with_key" if block.nil?

      original_hash.each_pair do |key, value|
        original_hash[key] = block.call(key, value)
      end

      original_hash
    end

    enum
  end
end
