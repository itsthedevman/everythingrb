# frozen_string_literal: true

#
# Extensions to Ruby's core Time class
#
# Provides:
# - #in_quotes, #with_quotes: Wrap time representations in quotes
#
# @example
#   require "everythingrb/time"
#
#   Time.new(2025, 5, 3).in_quotes
#
class Time
  include Everythingrb::StringQuotable
end
