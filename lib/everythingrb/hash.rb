# frozen_string_literal: true

#
# Extensions to Ruby's core Hash class
#
# Provides:
# - #to_struct, #to_ostruct, #to_istruct: Convert hashes to different structures
# - #join_map: Combine filter_map and join operations
# - #deep_freeze: Recursively freeze hash and contents
# - #transform_values.with_key: Transform values with access to keys
# - #transform, #transform!: Transform keys and values
# - #value_where, #values_where: Find values based on conditions
# - #rename_key, #rename_keys: Rename hash keys while preserving order
# - ::new_nested_hash: Create automatically nesting hashes
#
# @example
#   require "everythingrb/hash"
#   config = {server: {port: 443}}.to_ostruct
#   config.server.port  # => 443
#
class Hash
  include Everythingrb::InspectQuotable

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
  # Creates a new Hash that automatically initializes missing keys with nested hashes
  #
  # This method creates a hash where any missing key access will automatically
  # create another nested hash with the same behavior. You can control the nesting
  # depth with the depth parameter.
  #
  # @param depth [Integer, nil] The maximum nesting depth for automatic hash creation
  #   When nil (default), creates unlimited nesting depth
  #   When 0, behaves like a regular hash (returns nil for missing keys)
  #   When > 0, automatically creates hashes only up to the specified level
  #
  # @return [Hash] A hash that creates nested hashes for missing keys
  #
  # @example Unlimited nesting (default behavior)
  #   users = Hash.new_nested_hash
  #   users[:john][:role] = "admin"  # No need to initialize users[:john] first
  #   users # => {john: {role: "admin"}}
  #
  # @example Deep nesting without initialization
  #   stats = Hash.new_nested_hash
  #   stats[:server][:region][:us_east][:errors] = ["Error"]
  #   stats # => {server: {region: {us_east: {errors: ["Error"]}}}}
  #
  # @example Limited nesting depth
  #   hash = Hash.new_nested_hash(depth: 1)
  #   hash[:user][:name] = "Alice"  # Works fine - only one level of auto-creation
  #
  #   # This pattern works correctly with limited nesting:
  #   (hash[:user][:roles] ||= []) << "admin"
  #   hash # => {user: {name: "Alice", roles: ["admin"]}}
  #
  # @note While unlimited nesting is convenient, it can interfere with common Ruby
  #   patterns like ||= when initializing values at deep depths. Use the depth
  #   parameter to control this behavior.
  #
  def self.new_nested_hash(depth: nil)
    new do |hash, key|
      next if depth == 0

      hash[key] =
        if depth.nil?
          new_nested_hash
        else
          new_nested_hash(depth: depth - 1)
        end
    end
  end

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
  # Recursively converts all values that respond to #to_h
  #
  # Similar to #to_h but recursively traverses the Hash structure
  # and calls #to_h on any object that responds to it. Useful for
  # normalizing nested data structures and parsing nested JSON.
  #
  # @return [Hash] A deeply converted hash with all nested objects converted
  #
  # @example Converting nested Data objects
  #   user = { name: "Alice", metadata: Data.define(:source).new(source: "API") }
  #   user.to_deep_h  # => {name: "Alice", metadata: {source: "API"}}
  #
  # @example Parsing nested JSON strings
  #   nested = { profile: '{"role":"admin"}' }
  #   nested.to_deep_h  # => {profile: {role: "admin"}}
  #
  # @example Mixed nested structures
  #   data = {
  #     config: OpenStruct.new(api_key: "secret"),
  #     users: [
  #       Data.define(:name).new(name: "Bob"),
  #       {role: "admin"}
  #     ]
  #   }
  #   data.to_deep_h
  #   # => {
  #   #      config: {api_key: "secret"},
  #   #      users: [{name: "Bob"}, {role: "admin"}]
  #   #    }
  #
  def to_deep_h
    transform_values do |value|
      case value
      when Hash
        value.to_deep_h
      when Array
        value.to_deep_h
      when String
        # If the string is not valid JSON, #to_deep_h will return `nil`
        value.to_deep_h || value
      else
        value.respond_to?(:to_h) ? value.to_h : value
      end
    end
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
  # @note CAUTION: Be careful when freezing collections that contain class objects
  #   or singleton instances - this will freeze those classes/objects globally!
  #   Only use deep_freeze on pure data structures you want to make immutable.
  #
  def deep_freeze
    each_value { |v| v.respond_to?(:deep_freeze) ? v.deep_freeze : v.freeze }
    freeze
  end

  # Allows calling original method. See below
  alias_method :og_transform_values, :transform_values

  # Allows calling original method. See below
  alias_method :og_transform_values!, :transform_values!

  #
  # Returns a new hash with all values transformed by the block
  #
  # Enhances Ruby's standard transform_values with key access capability.
  #
  # @param with_key [Boolean] Whether to yield both value and key to the block
  #
  # @yield [value, key] Block that transforms each value
  # @yieldparam value [Object] The value to transform
  # @yieldparam key [Object] The corresponding key (only if with_key: true)
  # @yieldreturn [Object] The transformed value
  #
  # @return [Hash] A new hash with transformed values
  # @return [Enumerator] If no block is given
  #
  # @example Standard usage
  #   {a: 1, b: 2}.transform_values { |v| v * 2 }
  #   # => {a: 2, b: 4}
  #
  # @example With key access
  #   {a: 1, b: 2}.transform_values(with_key: true) { |v, k| "#{k}:#{v}" }
  #   # => {a: "a:1", b: "b:2"}
  #
  def transform_values(with_key: false, &block)
    return to_enum(:transform_values, with_key:) if block.nil?

    if with_key
      each_pair.with_object({}) do |(key, value), output|
        output[key] = block.call(value, key)
      end
    else
      og_transform_values(&block)
    end
  end

  #
  # Transforms all values in the hash in place
  #
  # Enhances Ruby's standard transform_values! with key access capability.
  #
  # @param with_key [Boolean] Whether to yield both value and key to the block
  #
  # @yield [value, key] Block that transforms each value
  # @yieldparam value [Object] The value to transform
  # @yieldparam key [Object] The corresponding key (only if with_key: true)
  # @yieldreturn [Object] The transformed value
  #
  # @return [self] The transformed hash
  # @return [Enumerator] If no block is given
  #
  # @example Standard usage
  #   hash = {a: 1, b: 2}
  #   hash.transform_values! { |v| v * 2 }
  #   # => {a: 2, b: 4}
  #   # hash is now {a: 2, b: 4}
  #
  # @example With key access
  #   hash = {a: 1, b: 2}
  #   hash.transform_values!(with_key: true) { |v, k| "#{k}:#{v}" }
  #   # => {a: "a:1", b: "b:2"}
  #   # hash is now {a: "a:1", b: "b:2"}
  #
  def transform_values!(with_key: false, &block)
    return to_enum(:transform_values!, with_key:) if block.nil?

    if with_key
      each_pair do |key, value|
        self[key] = block.call(value, key)
      end
    else
      og_transform_values!(&block)
    end
  end

  # ActiveSupport integrations
  if defined?(ActiveSupport)
    # Allows calling original method. See below
    alias_method :og_deep_transform_values, :deep_transform_values

    # Allows calling original method. See below
    alias_method :og_deep_transform_values!, :deep_transform_values!

    #
    # Recursively transforms all values in the hash and nested structures
    #
    # Walks through the hash and all nested hashes/arrays and yields each non-hash and
    # non-array value to the block, replacing it with the block's return value.
    #
    # @param with_key [Boolean] Whether to yield both value and key to the block
    #
    # @yield [value, key] Block that transforms each value
    # @yieldparam value [Object] The value to transform
    # @yieldparam key [Object] The corresponding key (only if with_key: true)
    # @yieldreturn [Object] The transformed value
    #
    # @return [Hash] A new hash with all values recursively transformed
    # @return [Enumerator] If no block is given
    #
    # @example Basic usage
    #   hash = {a: 1, b: {c: 2, d: [3, 4]}}
    #   hash.deep_transform_values { |v| v * 2 }
    #   # => {a: 2, b: {c: 4, d: [6, 8]}}
    #
    # @example With key access
    #   hash = {a: 1, b: {c: 2}}
    #   hash.deep_transform_values(with_key: true) { |v, k| "#{k}:#{v}" }
    #   # => {a: "a:1", b: {c: "c:2"}}
    #
    def deep_transform_values(with_key: false, &block)
      return to_enum(:deep_transform_values, with_key:) if block.nil?

      if with_key
        _deep_transform_values_with_key(self, nil, &block)
      else
        og_deep_transform_values(&block)
      end
    end

    #
    # Recursively transforms all values in the hash and nested structures in place
    #
    # Same as #deep_transform_values but modifies the hash in place.
    #
    # @param with_key [Boolean] Whether to yield both value and key to the block
    #
    # @yield [value, key] Block that transforms each value
    # @yieldparam value [Object] The value to transform
    # @yieldparam key [Object] The corresponding key (only if with_key: true)
    # @yieldreturn [Object] The transformed value
    #
    # @return [self] The transformed hash
    # @return [Enumerator] If no block is given
    #
    # @example Basic usage
    #   hash = {a: 1, b: {c: 2, d: [3, 4]}}
    #   hash.deep_transform_values! { |v| v * 2 }
    #   # => {a: 2, b: {c: 4, d: [6, 8]}}
    #   # hash is now {a: 2, b: {c: 4, d: [6, 8]}}
    #
    # @example With key access
    #   hash = {a: 1, b: {c: 2}}
    #   hash.deep_transform_values!(with_key: true) { |v, k| "#{k}:#{v}" }
    #   # => {a: "a:1", b: {c: "c:2"}}
    #   # hash is now {a: "a:1", b: {c: "c:2"}}
    #
    def deep_transform_values!(with_key: false, &block)
      return to_enum(:deep_transform_values!, with_key:) if block.nil?

      if with_key
        _deep_transform_values_with_key!(self, nil, &block)
      else
        og_deep_transform_values!(&block)
      end
    end

    # https://github.com/rails/rails/blob/main/activesupport/lib/active_support/core_ext/hash/deep_transform_values.rb#L25
    def _deep_transform_values_with_key(object, key, &block)
      case object
      when Hash
        object.transform_values(with_key: true) do |value, key|
          _deep_transform_values_with_key(value, key, &block)
        end
      when Array
        object.map do |value|
          _deep_transform_values_with_key(value, nil, &block)
        end
      else
        block.call(object, key)
      end
    end

    private :_deep_transform_values_with_key

    # https://github.com/rails/rails/blob/main/activesupport/lib/active_support/core_ext/hash/deep_transform_values.rb#L36
    def _deep_transform_values_with_key!(object, key, &block)
      case object
      when Hash
        object.transform_values!(with_key: true) do |value, key|
          _deep_transform_values_with_key!(value, key, &block)
        end
      when Array
        object.map! do |value|
          _deep_transform_values_with_key!(value, nil, &block)
        end
      else
        block.call(object, key)
      end
    end

    private :_deep_transform_values_with_key!
  end

  #
  # Transforms keys and values to create a new hash
  #
  # @yield [key, value] Block that returns a new key-value pair
  # @yieldparam key [Object] The original key
  # @yieldparam value [Object] The original value
  # @yieldreturn [Array] Two-element array containing the new key and value
  #
  # @return [Hash] A new hash with transformed keys and values
  # @return [Enumerator] If no block is given
  #
  # @example Transform both keys and values
  #   {a: 1, b: 2}.transform { |k, v| ["#{k}_key", v * 2] }
  #   # => {a_key: 2, b_key: 4}
  #
  def transform(&block)
    return to_enum(:transform) if block.nil?

    to_h(&block)
  end

  #
  # Transforms keys and values in place
  #
  # @yield [key, value] Block that returns a new key-value pair
  # @yieldparam key [Object] The original key
  # @yieldparam value [Object] The original value
  # @yieldreturn [Array] Two-element array containing the new key and value
  #
  # @return [self] The transformed hash
  # @return [Enumerator] If no block is given
  #
  # @example Transform both keys and values in place
  #   hash = {a: 1, b: 2}
  #   hash.transform! { |k, v| ["#{k}_key", v * 2] }
  #   # => {a_key: 2, b_key: 4}
  #
  def transform!(&block)
    return to_enum(:transform!) if block.nil?

    replace(transform(&block))
  end

  #
  # Returns the first value where the key-value pair satisfies the given condition
  #
  # @yield [key, value] Block that determines whether to include the value
  # @yieldparam key [Object] The current key
  # @yieldparam value [Object] The current value
  # @yieldreturn [Boolean] Whether to include this value
  #
  # @return [Object, nil] The first matching value or nil if none found
  # @return [Enumerator] If no block is given
  #
  # @example Find first admin user by role
  #   users = {
  #     alice: {name: "Alice", role: "admin"},
  #     bob: {name: "Bob", role: "user"},
  #     charlie: {name: "Charlie", role: "admin"}
  #   }
  #   users.value_where { |k, v| v[:role] == "admin" } # => {name: "Alice", role: "admin"}
  #
  def value_where(&block)
    return to_enum(:value_where) if block.nil?

    find(&block)&.last
  end

  #
  # Returns all values where the key-value pairs satisfy the given condition
  #
  # @yield [key, value] Block that determines whether to include the value
  # @yieldparam key [Object] The current key
  # @yieldparam value [Object] The current value
  # @yieldreturn [Boolean] Whether to include this value
  #
  # @return [Array] All matching values
  # @return [Enumerator] If no block is given
  #
  # @example Find all admin users by role
  #   users = {
  #     alice: {name: "Alice", role: "admin"},
  #     bob: {name: "Bob", role: "user"},
  #     charlie: {name: "Charlie", role: "admin"}
  #   }
  #   users.values_where { |k, v| v[:role] == "admin" }
  #   # => [{name: "Alice", role: "admin"}, {name: "Charlie", role: "admin"}]
  #
  def values_where(&block)
    return to_enum(:values_where) if block.nil?

    select(&block).values
  end

  #
  # Renames a key in the hash while preserving the original order of elements
  #
  # @param old_key [Object] The key to rename
  # @param new_key [Object] The new key to use
  #
  # @return [Hash] A new hash with the key renamed
  #
  # @example Renames a single key
  #   {a: 1, b: 2, c: 3}.rename_key(:b, :middle)
  #   # => {a: 1, middle: 2, c: 3}
  #
  def rename_key(old_key, new_key)
    rename_keys(old_key => new_key)
  end

  #
  # Renames a key in the hash in place while preserving the original order of elements
  #
  # @param old_key [Object] The key to rename
  # @param new_key [Object] The new key to use
  #
  # @return [self] The modified hash
  #
  # @example Renames a key in place
  #   hash = {a: 1, b: 2, c: 3}
  #   hash.rename_key!(:b, :middle)
  #   # => {a: 1, middle: 2, c: 3}
  #
  def rename_key!(old_key, new_key)
    rename_keys!(old_key => new_key)
  end

  #
  # Renames multiple keys in the hash while preserving the original order of elements
  #
  # This method maintains the original order of all keys in the hash, renaming
  # only the specified keys while keeping their positions unchanged.
  #
  # @param keys [Hash] A mapping of old_key => new_key pairs
  #
  # @return [Hash] A new hash with keys renamed
  #
  # @example Renames multiple keys
  #   {a: 1, b: 2, c: 3, d: 4}.rename_keys(a: :first, c: :third)
  #   # => {first: 1, b: 2, third: 3, d: 4}
  #
  def rename_keys(**keys)
    # I tried multiple different ways to rename the key while preserving the order, this was the fastest
    transform_keys do |key|
      keys.key?(key) ? keys[key] : key
    end
  end

  #
  # Renames multiple keys in the hash in place while preserving the original order of elements
  #
  # This method maintains the original order of all keys in the hash, renaming
  # only the specified keys while keeping their positions unchanged.
  #
  # @param keys [Hash] A mapping of old_key => new_key pairs
  #
  # @return [self] The modified hash
  #
  # @example Rename multiple keys in place
  #   hash = {a: 1, b: 2, c: 3, d: 4}
  #   hash.rename_keys!(a: :first, c: :third)
  #   # => {first: 1, b: 2, third: 3, d: 4}
  #
  def rename_keys!(**keys)
    # I tried multiple different ways to rename the key while preserving the order, this was the fastest
    transform_keys! do |key|
      keys.key?(key) ? keys[key] : key
    end
  end

  #
  # Renames a key in the hash without preserving element order (faster)
  #
  # This method is significantly faster than #rename_key but does not
  # guarantee that the order of elements in the hash will be preserved.
  #
  # @param old_key [Object] The key to rename
  # @param new_key [Object] The new key to use
  #
  # @return [Hash] A new hash with the key renamed
  #
  # @example Rename a single key without preserving order
  #   {a: 1, b: 2, c: 3}.rename_key_unordered(:b, :middle)
  #   # => {a: 1, c: 3, middle: 2}  # Order may differ
  #
  def rename_key_unordered(old_key, new_key)
    # Fun thing I learned. For small hashes, using #except is 1.5x faster than using dup and delete.
    # But as the hash becomes larger, the performance improvements become diminished until they're roughly the same.
    # Neat!
    hash = except(old_key)
    hash[new_key] = self[old_key]
    hash
  end

  #
  # Renames a key in the hash in place without preserving element order (faster)
  #
  # This method is significantly faster than #rename_key! but does not
  # guarantee that the order of elements in the hash will be preserved.
  #
  # @param old_key [Object] The key to rename
  # @param new_key [Object] The new key to use
  #
  # @return [self] The modified hash
  #
  # @example Rename a key in place without preserving order
  #   hash = {a: 1, b: 2, c: 3}
  #   hash.rename_key_unordered!(:b, :middle)
  #   # => {a: 1, c: 3, middle: 2}  # Order may differ
  #
  def rename_key_unordered!(old_key, new_key)
    self[new_key] = delete(old_key)
    self
  end
end
