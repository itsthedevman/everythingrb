# frozen_string_literal: true

#
# Extensions to Ruby's core TrueClass
#
# Provides:
# - #in_quotes, #with_quotes: Wrap boolean values in quotes
#
# @example
#   require "everythingrb/boolean"
#
#   true.in_quotes   # => "\"true\""
#   false.in_quotes  # => "\"false\""
#
class TrueClass
  include Everythingrb::InspectQuotable
end

#
# Extensions to Ruby's core FalseClass
#
# Provides:
# - #in_quotes, #with_quotes: Wrap boolean values in quotes
#
# @example
#   require "everythingrb/boolean"
#
#   true.in_quotes   # => "\"true\""
#   false.in_quotes  # => "\"false\""
#
class FalseClass
  include Everythingrb::InspectQuotable
end
