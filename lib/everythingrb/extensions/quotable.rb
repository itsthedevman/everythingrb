# frozen_string_literal: true

#
# Extensions for making objects quotable with double quotes
#
# These modules add the ability to quote objects by wrapping
# their string representations in double quotes. This is useful for
# generating error messages, debug output, or formatted logs where
# you want to clearly distinguish between different value types.
#
# @example Basic usage with different types
#   1.in_quotes                   # => "\"1\""
#   nil.in_quotes                 # => "\"nil\""
#   "hello".in_quotes             # => "\"\\\"hello\\\"\""
#   [1, 2, 3].in_quotes           # => "\"[1, 2, 3]\""
#
# @example Using with collections
#   values = [1, nil, "hello"]
#   values.map(&:in_quotes)       # => ["\"1\"", "\"nil\"", "\"\\\"hello\\\"\""]
#
# @example Error messages
#   expected = 42
#   actual = nil
#   raise "Expected #{expected.in_quotes} but got #{actual.in_quotes}"
#   # => "Expected \"42\" but got \"nil\""
#
module Everythingrb
  #
  # Adds quotable functionality using inspect representation
  #
  # Provides methods for wrapping an object's inspection
  # representation in double quotes.
  #
  # @example
  #   [1, 2, 3].in_quotes  # => "\"[1, 2, 3]\""
  #
  module InspectQuotable
    #
    # Adds quotable functionality using inspect representation
    #
    # Provides methods for wrapping an object's inspection
    # representation in double quotes.
    #
    # @return [String] The object's inspect representation surrounded by double quotes
    #
    # @example
    #   [1, 2, 3].in_quotes      # => "\"[1, 2, 3]\""
    #   {a: 1}.in_quotes         # => "\"{:a=>1}\""
    #
    def in_quotes
      %("#{inspect}")
    end

    alias_method :with_quotes, :in_quotes
  end

  #
  # Adds quotable functionality using to_s representation
  #
  # Provides methods for wrapping an object's string
  # representation in double quotes.
  #
  # @example
  #   Time.now.in_quotes  # => "\"2025-05-03 12:34:56 -0400\""
  #
  module StringQuotable
    #
    # Returns the object's string representation wrapped in double quotes
    #
    # @return [String] The object's to_s representation surrounded by double quotes
    #
    # @example
    #   Date.today.in_quotes      # => "\"2025-05-03\""
    #   Time.now.in_quotes        # => "\"2025-05-03 12:34:56 -0400\""
    #
    def in_quotes
      %("#{self}")
    end

    alias_method :with_quotes, :in_quotes
  end
end
