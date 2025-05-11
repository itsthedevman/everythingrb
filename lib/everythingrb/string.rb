# frozen_string_literal: true

#
# Extensions to Ruby's core String class
#
# Provides:
# - #to_h, #to_a: Convert JSON strings to Hash/Array with error handling
# - #to_deep_h: Recursively parse nested JSON strings
# - #to_ostruct, #to_istruct, #to_struct: Convert JSON to data structures
# - #with_quotes, #in_quotes: Wrap strings in quotes
# - #to_camelcase: Convert strings to camelCase or PascalCase
#
# @example
#   require "everythingrb/string"
#
#   '{"user": {"name": "Alice"}}'.to_ostruct.user.name  # => "Alice"
#   "Hello".with_quotes  # => "\"Hello\""
#   "hello_world".to_camelcase  # => "HelloWorld"
#
class String
  include Everythingrb::StringQuotable

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
  # @return [nil] If the string is not valid JSON at the top level
  #
  # @note If nested JSON strings fail to parse, they remain as strings
  #   rather than causing the entire operation to fail
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
  # Converts a string to camelCase or PascalCase
  #
  # Handles strings with spaces, hyphens, underscores, and special characters.
  # - Hyphens and underscores are treated like spaces
  # - Special characters and symbols are removed
  # - Capitalizing each word (except the first if set)
  #
  # @param first_letter [Symbol] Whether the first letter should be uppercase (:upper)
  #   or lowercase (:lower)
  #
  # @return [String] The camelCased string
  #
  # @example Convert a string to PascalCase (default)
  #   "welcome to the jungle!".to_camelcase     # => "WelcomeToTheJungle"
  #
  # @example Convert a string to camelCase (lowercase first)
  #   "welcome to the jungle!".to_camelcase(:lower)     # => "welcomeToTheJungle"
  #
  # @example With mixed formatting
  #   "please-WAIT while_loading...".to_camelcase    # => "PleaseWaitWhileLoading"
  #
  # @see String#capitalize
  # @see String#downcase
  #
  def to_camelcase(first_letter = :upper)
    gsub(/[-_]/, " ") # Treat dash/underscore as new words so they are capitalized
      .gsub(/[^a-zA-Z0-9\s]/, "") # Remove any special characters
      .split(/\s+/) # Split by word (removes extra whitespace)
      .map # Don't use `join_map(with_index: true)`, this is faster
      .with_index do |word, index| # Convert the words
        if index == 0 && first_letter == :lower
          word.downcase
        else
          word.capitalize
        end
      end
      .join # And join it back together
  end
end
