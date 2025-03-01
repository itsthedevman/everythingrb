# frozen_string_literal: true

class String
  #
  # Converts JSON string to Hash, returning nil if it failed
  #
  # @return [Hash, nil] Parsed JSON as hash
  #
  def to_h
    JSON.parse(self, symbolize_names: true)
  rescue JSON::ParserError
    nil
  end

  alias_method :to_a, :to_h

  #
  # Deep parsing of nested JSON strings
  # Recursively attempts to parse string values as JSON
  #
  # @return [Hash] Deeply parsed hash
  #
  def to_deep_h
    recursive_convert = lambda do |object|
      case object
      when Array
        object.map { |v| recursive_convert.call(v) }
      when String
        result = object.to_deep_h

        # Nested JSON
        if result.is_a?(Array) || result.is_a?(Hash)
          recursive_convert.call(result)
        else
          object
        end
      when Hash
        object.transform_values { |v| recursive_convert.call(v) }
      else
        object
      end
    end

    recursive_convert.call(to_h)
  end

  #
  # Attempts to parse JSON and convert to Data struct.
  # Returns nil if string does not contain valid JSON
  #
  # @return [nil, Data]
  #
  def to_istruct
    to_h&.to_istruct
  end

  #
  # Attempts to parse JSON and convert to OpenStruct.
  # Returns nil if string does not contain valid JSON
  #
  # @return [nil, OpenStruct]
  def to_ostruct
    to_h&.to_ostruct
  end

  #
  # Attempts to parse JSON and convert to Struct.
  # Returns nil if string does not contain valid JSON
  #
  # @return [nil, Struct]
  #
  def to_struct
    to_h&.to_struct
  end

  #
  # Returns self wrapped in double quotes.
  #
  # @return [String]
  #
  def with_quotes
    %("#{self}")
  end

  alias_method :in_quotes, :with_quotes
end
