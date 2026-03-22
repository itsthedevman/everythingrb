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
  # Creates predicate (boolean) methods that return true/false based on an attribute's value.
  # Similar to attr_reader, attr_writer, etc. Designed to work with regular classes, Struct,
  # and Data objects.
  #
  # Values are evaluated as follows:
  # - nil and false are always false
  # - With ActiveSupport: uses +present?+ (empty strings, arrays, hashes are false)
  # - Without ActiveSupport: checks +empty?+ if available, otherwise uses truthiness
  #
  # @param attributes [Array<Symbol, String>] Attribute names
  # @param opts [Hash] Options hash
  # @option opts [Symbol, String, nil] :from Source ivar or method to read from. Use @ prefix
  #   for instance variables (e.g., :@started_at), omit for methods (e.g., :status). When
  #   specified, only one attribute may be provided (ambiguous mapping otherwise).
  # @option opts [Boolean] :private If true, defines the predicate as a private method
  #
  # @return [nil]
  #
  # @raise [ArgumentError] If a predicate method of the same name already exists
  # @raise [ArgumentError] If from: is specified with multiple attributes
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
  # @example Mapping to a different ivar with from:
  #   class Task
  #     attr_accessor :started_at, :stopped_at
  #     attr_predicate :started, from: :@started_at
  #     attr_predicate :finished, from: :@stopped_at
  #   end
  #
  #   task = Task.new
  #   task.started? # => false
  #   task.started_at = Time.now
  #   task.started? # => true
  #
  # @example Mapping to a method with from:
  #   class Job
  #     attr_accessor :error_messages
  #     attr_predicate :errored, from: :error_messages
  #   end
  #
  #   job = Job.new
  #   job.errored? # => false
  #   job.error_messages = ["Something went wrong"]
  #   job.errored? # => true
  #
  # @example Private predicate method
  #   class Account
  #     attr_accessor :verified
  #     attr_predicate :verified, private: true
  #   end
  #
  #   account = Account.new
  #   account.verified? # => NoMethodError (private method)
  #
  def attr_predicate(*attributes, **opts)
    from = opts[:from]
    private_method = !!opts[:private]

    if from && attributes.size > 1
      raise ArgumentError, "Cannot use from: option with multiple attributes - each predicate needs its own source mapping"
    end

    attributes.each do |attribute|
      if method_defined?(:"#{attribute}?")
        raise ArgumentError, "Cannot create predicate method on #{self.class} - #{attribute}? is already defined. Please choose a different name or remove the existing method."
      end

      signature = "def #{attribute}?"
      signature.prepend("private ") if private_method

      # Performance note:
      # This was originally checked if an instance variable or method was defined, both of which are sllllooooowwwww
      # Now as of 1.0.0, this assumes an instance variable (with exceptions) by default
      getter =
        if from
          from.to_s.start_with?("@") ? from : "self.#{from}"
        elsif self < Struct || self < OpenStruct || self < Data
          "self.#{attribute}"
        else
          "@#{attribute}"
        end

      checker =
        if defined?(ActiveSupport)
          "!!value.presence"
        else
          # Handle empty arrays/hashes/strings
          "value.respond_to?(:empty?) ? !value.empty? : !!value"
        end

      module_eval <<~RUBY, __FILE__, __LINE__ + 1
        #{signature}
          value = #{getter}
          return false if value.nil?

          #{checker}
        end
      RUBY
    end

    nil
  end
end
