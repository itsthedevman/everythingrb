# frozen_string_literal: true

#
# Makes objects quotable with double quotes around their string representation
#
# The Quotable module adds the ability to quote any object's string
# representation by wrapping it in double quotes. This is useful for
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
  module Quotable
    #
    # Returns the object's string representation wrapped in double quotes
    #
    # @return [String] The object's inspect representation surrounded by double quotes
    #
    # @example
    #   1.in_quotes      # => "\"1\""
    #   nil.in_quotes    # => "\"nil\""
    #
    def in_quotes
      %("#{inspect}")
    end

    alias_method :with_quotes, :in_quotes
  end
end
