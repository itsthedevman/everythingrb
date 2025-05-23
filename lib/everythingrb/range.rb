# frozen_string_literal: true

#
# Extensions to Ruby's core Range class
#
# Provides:
# - #in_quotes, #with_quotes: Wrap range representations in quotes
#
# @example
#   require "everythingrb/range"
#
#   (1..5).in_quotes     # => "\"1..5\""
#   ('a'..'z').in_quotes # => "\"a..z\""
#
#   # Helpful in error messages:
#   raise "Expected value in #{valid_range.in_quotes}"
#
class Range
  include Everythingrb::InspectQuotable
end
