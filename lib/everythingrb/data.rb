# frozen_string_literal: true

#
# Extensions to Ruby's core Data class
#
# Provides:
# - #in_quotes, #with_quotes: Wrap object in quotes
#
class Data
  include Everythingrb::InspectQuotable
end
