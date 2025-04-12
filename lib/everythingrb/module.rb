# frozen_string_literal: true

#
# Extensions to Ruby's core Module class
#
# Provides:
# - #attr_predicate: Create boolean-style accessor methods
#
# @example
#   require "everythingrb/module"
#
#   class User
#     attr_accessor :admin
#     attr_predicate :admin
#   end
#
#   user = User.new
#   user.admin = true
#   user.admin?  # => true
#
class Module
  #
  # Creates predicate (boolean) methods that return true/false
  # Similar to attr_reader, attr_writer, etc. Designed to work with
  # regular classes, Struct, and Data objects.
  #
  # Note: If ActiveSupport is loaded, this will check if the value is present? instead of truthy
  #
  # @param attributes [Array<Symbol, String>] Attribute names
  #
  # @return [nil]
  #
  # @raise [ArgumentError] If a predicate method of the same name already exists
  #
  # @example With a regular class
  #   class User
  #     attr_predicate :admin
  #     attr_accessor :admin
  #   end
  #
  #   user = User.new
  #   user.admin? # => false
  #   user.admin = true
  #   user.admin? # => true
  #
  # @example With Struct/Data
  #   Person = Struct.new(:active)
  #   Person.attr_predicate(:active)
  #
  #   person = Person.new(active: true)
  #   person.active? # => true
  #
  def attr_predicate(*attributes)
    attributes.each do |attribute|
      if method_defined?(:"#{attribute}?")
        raise ArgumentError, "Cannot create predicate method on #{self.class} - #{attribute}? is already defined. Please choose a different name or remove the existing method."
      end

      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attribute}?
          value =
            if instance_variable_defined?(:@#{attribute})
              @#{attribute}
            elsif respond_to?(:#{attribute})
              self.#{attribute}
            end

          return false if value.nil?

          defined?(ActiveSupport) ? !!value.presence : !!value
        end
      RUBY
    end

    nil
  end
end
