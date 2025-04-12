# frozen_string_literal: true

#
# Extensions to Ruby's core String class
#
# Provides:
# - #to_h, #to_a: Convert JSON strings to Hash/Array with error handling
# - #to_deep_h: Recursively parse nested JSON strings
# - #to_ostruct, #to_istruct, #to_struct: Convert JSON to data structures
# - #with_quotes, #in_quotes: Wrap strings in quotes
#
# @example
#   require "everythingrb/string"
#
#   '{"user": {"name": "Alice"}}'.to_ostruct.user.name  # => "Alice"
#   "Hello".with_quotes  # => "\"Hello\""
#
class String
  #
  # Converts JSON string to Hash, returning nil if it failed
  #
  # @return [Hash, nil] Parsed JSON as hash or nil if invalid JSON
  #
  # @example
  #   '{"name": "Alice"}'.to_h  # => {name: "Alice"}
  #   "invalid json".to_h       # => nil
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
  # @return [Hash] Deeply parsed hash with all nested JSON strings converted
  #
  # @example
  #   nested_json = '{
  #     "user": "{\"name\":\"Alice\",\"roles\":[\"admin\"]}"
  #   }'
  #   nested_json.to_deep_h
  #   # => {user: {name: "Alice", roles: ["admin"]}}
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
  # @return [Data, nil] Immutable Data structure or nil if invalid JSON
  #
  # @example
  #   '{"name": "Alice"}'.to_istruct      # => #<data name="Alice">
  #   "not json".to_istruct               # => nil
  #
  def to_istruct
    to_h&.to_istruct
  end

  #
  # Attempts to parse JSON and convert to OpenStruct.
  # Returns nil if string does not contain valid JSON
  #
  # @return [OpenStruct, nil] OpenStruct or nil if invalid JSON
  #
  # @example
  #   '{"name": "Alice"}'.to_ostruct      # => #<OpenStruct name="Alice">
  #   "not json".to_ostruct               # => nil
  #
  def to_ostruct
    to_h&.to_ostruct
  end

  #
  # Attempts to parse JSON and convert to Struct.
  # Returns nil if string does not contain valid JSON
  #
  # @return [Struct, nil] Struct or nil if invalid JSON
  #
  # @example
  #   '{"name": "Alice"}'.to_struct       # => #<struct name="Alice">
  #   "not json".to_struct                # => nil
  #
  def to_struct
    to_h&.to_struct
  end

  #
  # Returns self wrapped in double quotes
  #
  # @return [String] The string with surrounding double quotes
  #
  # @example
  #   "Hello World".with_quotes           # => "\"Hello World\""
  #   "Quote \"me\"".with_quotes          # => "\"Quote \\\"me\\\"\""
  #
  def with_quotes
    %("#{self}")
  end

  alias_method :in_quotes, :with_quotes
end
