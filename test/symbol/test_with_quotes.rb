# frozen_string_literal: true

require "test_helper"

class TestSymbolWithQuotes < Minitest::Test
  def test_it_wraps_in_quotes
    assert_equal(:"\"hello_world\"", :hello_world.with_quotes)
    assert_equal(:"\"hello_world\"", :hello_world.in_quotes)
  end
end
