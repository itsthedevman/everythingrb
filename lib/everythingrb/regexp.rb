# frozen_string_literal: true

#
# Extensions to Ruby's core Regexp class
#
# Provides:
# - #in_quotes, #with_quotes: Wrap regular expression representations in quotes
#
# @example
#   require "everythingrb/regexp"
#
#   /\d+/.in_quotes  # => "\"/\\d+/\""
#
class Regexp
  include Everythingrb::InspectQuotable
end
