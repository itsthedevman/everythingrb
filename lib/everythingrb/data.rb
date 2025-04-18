# frozen_string_literal: true

#
# Extensions to Ruby's core Data class
#
# Provides:
# - #to_deep_h: Recursively convert to hash with all nested objects
#
class Data
  #
  # Recursively converts the Data object and all nested objects to hashes
  #
  # @return [Hash] A deeply converted hash of the Data object
  #
  # @example
  #   Person = Data.define(:name, :profile)
  #   person = Person.new(name: "Alice", profile: {roles: ["admin"]})
  #   person.to_deep_h  # => {name: "Alice", profile: {roles: ["admin"]}}
  #
  def to_deep_h
    to_h.to_deep_h
  end
end
