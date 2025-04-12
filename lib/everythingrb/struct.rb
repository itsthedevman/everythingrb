# frozen_string_literal: true

#
# Extensions to Ruby's core Struct class
#
# Provides:
# - #to_deep_h: Recursively convert to hash with all nested objects
#
# @example
#   require "everythingrb/struct"
#
#   Person = Struct.new(:name, :profile)
#   person = Person.new("Alice", {roles: ["admin"]})
#   person.to_deep_h  # => {name: "Alice", profile: {roles: ["admin"]}}
#
class Struct
  #
  # Recursively converts the Struct and all nested objects to hashes
  #
  # @return [Hash] A deeply converted hash of the Struct
  #
  # @example
  #   Address = Struct.new(:city, :country)
  #   Person = Struct.new(:name, :address)
  #   person = Person.new("Alice", Address.new("New York", "USA"))
  #   person.to_deep_h  # => {name: "Alice", address: {city: "New York", country: "USA"}}
  #
  def to_deep_h
    to_h.to_deep_h
  end
end
