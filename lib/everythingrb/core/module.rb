# frozen_string_literal: true

class Module
  #
  # Creates predicate (boolean) methods for instance variables
  # Similar to attr_reader, attr_writer, etc.
  #
  # @param *attributes [Array<Symbol, String>] Instance variable names
  # @return [nil]
  #
  # @example
  #   class User
  #     attr_predicate :admin, :active
  #   end
  #
  #   user.admin? # => true/false based on @admin
  #
  def attr_predicate(*attributes)
    attributes.each do |attribute|
      module_eval <<-STR, __FILE__, __LINE__ + 1
        def #{attribute}?
          !!instance_variable_get("@#{attribute}")
        end
      STR
    end

    nil
  end
end
