# frozen_string_literal: true

#
# Extensions to Ruby's core Symbol class
#
# Provides:
# - #with_quotes, #in_quotes: Wrap symbols in quotes
#
# @example
#   require "everythingrb/symbol"
#
#   :hello_world.with_quotes  # => :"\"hello_world\""
#
class Symbol
  #
  # Returns self wrapped in double quotes
  #
  # @return [Symbol] The symbol with surrounding double quotes
  #
  # @example
  #   :hello_world.with_quotes  # => :"\"hello_world\""
  #   :hello_world.in_quotes    # => :"\"hello_world\""
  #
  def with_quotes
    :"\"#{self}\""
  end

  alias_method :in_quotes, :with_quotes
end
