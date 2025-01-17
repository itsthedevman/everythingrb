# frozen_string_literal: true

class OpenStruct
  if defined?(ActiveSupport)
    #
    # Checks if the OpenStruct has no attributes
    #
    # @return [Boolean]
    #
    def blank?
      @table.blank?
    end

    #
    # Checks if the OpenStruct has any attributes
    #
    # @return [Boolean]
    #
    def present?
      @table.present?
    end
  end

  alias_method :each, :each_pair

  #
  # Maps over OpenStruct entries and returns an array
  #
  # @return [Enumerator, Array] Returns a new array, or enumerator if block is nil
  #
  def map(&)
    @table.map(&)
  end

  #
  # Maps over OpenStruct entries and returns an array without nil values
  #
  # @return [Enumerator, Array] Returns a new array, or enumerator if block is nil
  #
  def filter_map(&block)
    return enum_for(:filter_map) unless block

    map(&block).compact
  end

  #
  # Combines filter_map and join operations
  #
  # @param join_with [String] The delimiter to join elements with (defaults to empty string)
  #
  # @yield [Object] Block that filters and transforms hash elements
  #
  # @return [String] Joined string of filtered and transformed elements
  #
  # @example
  #   object = OpenStruct.new(a: 1, b: nil, c: 3)
  #   object.join_map(" ") { |k, v| "#{k}-#{v}" if v }
  #   # => "a-1 c-3"
  #
  # @example
  #   object = OpenStruct.new(a: 1, b: nil, c: 3)
  #   object.join_map(", ")
  #   # => "a, 1, b, c, 3"
  #
  def join_map(join_with = "", &block)
    block = ->(kv_pair) { kv_pair.compact } if block.nil?

    filter_map(&block).join(join_with)
  end

  #
  # @return [self]
  #
  def to_ostruct
    self
  end
end
