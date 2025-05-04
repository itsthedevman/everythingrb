# frozen_string_literal: true

#
# Extensions to Ruby's core Numeric class and subclasses
#
# Provides:
# - #in_quotes, #with_quotes: Wrap numeric values in quotes
#
# @example
#   require "everythingrb/numeric"
#
#   42.in_quotes      # => "\"42\""
#   3.14.in_quotes    # => "\"3.14\""
#   (1+2i).in_quotes  # => "\"1+2i\""
#
class Numeric
  include Everythingrb::InspectQuotable
end
