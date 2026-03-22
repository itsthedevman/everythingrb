# frozen_string_literal: true

#
# Extensions to Ruby's core String class
#
# Provides:
# - #parse_json: Parse JSON strings with error handling
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
  # Parses the string as JSON and returns the result
  #
  # Safely parses JSON with symbolized keys by default. Returns nil
  # instead of raising an exception if the string is not valid JSON.
  #
  # @param opts [Hash] Options to pass to JSON.parse
  # @option opts [Boolean] :symbolize_names (true) Whether to symbolize keys
  #
  # @return [Hash, Array, nil] Parsed JSON or nil if invalid
  #
  # @example Basic usage
  #   '{"name": "Alice"}'.parse_json  # => {name: "Alice"}
  #
  # @example With nested data
  #   '{"user": {"roles": ["admin"]}}'.parse_json
  #   # => {user: {roles: ["admin"]}}
  #
  # @example Invalid JSON returns nil
  #   "not json".parse_json  # => nil
  #
  # @example Disable symbolized keys
  #   '{"name": "Alice"}'.parse_json(symbolize_names: false)
  #   # => {"name" => "Alice"}
  #
  def parse_json(**opts)
    opts[:symbolize_names] = true unless opts.key?(:symbolize_names)

    JSON.parse(self, opts)
  rescue JSON::ParserError
    nil
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
    parse_json&.to_istruct
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
    parse_json&.to_ostruct
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
    parse_json&.to_struct
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
