# frozen_string_literal: true

#
# Extensions to Ruby's core Date class
#
# Provides:
# - #in_quotes, #with_quotes: Wrap date representations in quotes
#
# @example
#   require "everythingrb/date"
#
#   Date.today.in_quotes
#
class Date
  include Everythingrb::StringQuotable
end

#
# Extensions to Ruby's core DateTime class
#
# Provides:
# - #in_quotes, #with_quotes: Wrap time representations in quotes
#
# @example
#   require "everythingrb/date"
#
#   DateTime.now.in_quotes
#
class DateTime < Date
  include Everythingrb::StringQuotable
end
