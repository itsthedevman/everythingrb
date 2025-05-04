# frozen_string_literal: true

#
# Extensions to Ruby's NilClass
#
# Provides:
# - #in_quotes, #with_quotes: Wrap nil's string representation in quotes
#
# @example
#   require "everythingrb/extensions/nil_class"
#   nil.in_quotes  # => "\"nil\""
#
class NilClass
  include Everythingrb::InspectQuotable
end
