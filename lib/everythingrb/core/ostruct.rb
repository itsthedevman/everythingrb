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

  #
  # Adds enumeration
  #
  # @yield [String, Object] Block receives key (as string) and value
  #
  # @return [Enumerator, self] Returns self, or enumerator if block is nil
  #
  #
  def each(&block)
    return @table.each if block.nil?

    @table.each do |key, value|
      yield(key, value)
    end

    self
  end

  #
  # Maps over OpenStruct entries and returns an array
  #
  # @return [Enumerator, Array] Returns a new array, or enumerator if block is nil
  #
  def map(&block)
    return @table.map if block.blank?

    @table.map do |key, value|
      yield(key, value)
    end
  end

  #
  # @return [self]
  #
  def to_ostruct
    self
  end

  #
  # Converts OpenStruct to hash recursively
  #
  # @return [Hash]
  #
  def to_h
    @table.each_with_object({}) do |(key, value), hash|
      key =
        if key.respond_to?(:to_h)
          key.to_h
        else
          key
        end

      value =
        if value.respond_to?(:to_h)
          value.to_h
        else
          value
        end

      hash[key] = value
    end
  end
end
