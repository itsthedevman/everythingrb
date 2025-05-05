# frozen_string_literal: true

#
# Extensions to Ruby's core Kernel module
#
# Provides:
# - #morph: A more intuitive alias for Kernel#then (yield_self)
#
# @example
#   require "everythingrb/kernel"
#
#   version.get_info.morph { |v| "#{v.major}.#{v.minor}" }
#
module Kernel
  #
  # Transforms the receiver by passing it to the given block and returning the block's result
  #
  # This method is an alias for `then` (and `yield_self`) that more clearly communicates
  # the transformation intent.
  #
  # @yield [receiver] Block that transforms the receiver
  # @yieldparam receiver [Object] The receiver object
  # @yieldreturn [Object] The transformed result
  #
  # @return [Object] The result of the block
  #
  # @example Convert a semantic version to a string
  #   version.to_sem_version.morph { |v| "#{v.major}.#{v.minor}" }
  #
  alias_method :morph, :then
end
