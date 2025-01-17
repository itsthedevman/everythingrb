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

  # @return [OpenStruct] Parsed JSON as OpenStruct
  def to_ostruct
    JSON.parse(self, object_class: OpenStruct)
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
  # Attempts to parse JSON and convert to Data struct.
  # Returns nil if string does not contain valid JSON
  #
  # @return [nil, Data]
  #
  def to_istruct
    to_h&.to_istruct
  end

  #
  # Deep parsing of nested JSON strings
  # Recursively attempts to parse string values as JSON
  #
  # @return [Hash] Deeply parsed hash
  #
  def to_deep_h
    transformer = lambda do |object|
      case object
      when Array
        object.map { |v| transformer.call(v) }
      when String
        result = object.to_deep_h

        case result
        when Array, Hash
          transformer.call(result)
        else
          object
        end
      when Hash
        object.transform_values { |v| transformer.call(v) }
      else
        object
      end
    end

    transformer.call(to_h)
  end
end
