# frozen_string_literal: true

#
# Extensions to Ruby's core Struct class
#
# Provides:
# - #in_quotes, #with_quotes: Wrap struct in quotes
#
# @example
#   require "everythingrb/struct"
#
#   Person = Struct.new(:name, :profile)
#   person = Person.new("Alice", {roles: ["admin"]})
#
class Struct
  include Everythingrb::InspectQuotable
end
