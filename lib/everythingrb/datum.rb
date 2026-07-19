# frozen_string_literal: true

#
# An immutable, dot-notation object built from attributes in a single call
#
# Think of it as the sealed counterpart to OpenStruct: the ergonomics of OpenStruct.new(hash) with the
# immutability of Data. Values are stored as-is (nested hashes and arrays are left untouched), so the object is
# immutable only at the top level. Use Hash#to_datum when you want the conversion to recurse.
#
# @example Build an object inline
#   config = Datum.new(host: "localhost", port: 3000)
#   config.host # => "localhost"
#
# @example Nested data is left as-is
#   data = Datum.new(name: "Bob", meta: {role: "admin"})
#   data.meta # => {role: "admin"} (still a Hash)
#
# @example Structural equality
#   Datum.new(a: 1) == Datum.new(a: 1) # => true
#
class Datum < Data
  #
  # Builds an immutable object from the given attributes
  #
  # @param attributes [Hash] The members and their values for the new object
  #
  # @return [Datum] An object whose members match the given keys
  #
  # @example
  #   Datum.new(host: "localhost", port: 3000)
  #
  def self.new(attributes = {})
    define(*attributes.keys.map(&:to_sym)).new(*attributes.values)
  end

  #
  # Compares against another Datum by attributes rather than by class
  #
  # Every Datum is backed by its own anonymous Data class, so the default
  # comparison (which requires an identical class) would never match. This
  # compares the underlying attributes instead.
  #
  # @param other [Object] The object to compare against
  #
  # @return [Boolean] True when other is a Datum with equal attributes
  #
  def ==(other)
    other.is_a?(Datum) && to_h == other.to_h
  end

  alias_method :eql?, :==

  #
  # Returns a hash code derived from the attributes
  #
  # Keeps #hash consistent with #eql? so equal Datums collapse to the same
  # Hash key or Set member.
  #
  # @return [Integer]
  #
  def hash
    to_h.hash
  end
end
