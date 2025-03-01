# frozen_string_literal: true

require "test_helper"

class TestWithQuotes < Minitest::Test
  def test_it_wraps_in_quotes
    assert_equal("\"Hello World\"", "Hello World".with_quotes)
    assert_equal("\"Hello World\"", "Hello World".in_quotes)
  end

  def tests_it_allow_quotes
    assert_equal("\"\"My heart is pumping. Get on your feet\"\"", "\"My heart is pumping. Get on your feet\"".in_quotes)
  end
end
