# frozen_string_literal: true

#
# Extensions to Ruby's core Symbol class
#
# These additions provide handy formatting helpers for symbols.
#
# @example
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
