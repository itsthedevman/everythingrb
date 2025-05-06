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
#   # Useful in debugging output:
#   puts "Pattern used: #{pattern.in_quotes}"
#
class Regexp
  include Everythingrb::InspectQuotable
end
