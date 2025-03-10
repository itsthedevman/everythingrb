# frozen_string_literal: true

class Symbol
  #
  # Returns self wrapped in double quotes.
  #
  # @return [Symbol]
  #
  def with_quotes
    :"\"#{self}\""
  end

  alias_method :in_quotes, :with_quotes
end
