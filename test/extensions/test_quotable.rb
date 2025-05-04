# frozen_string_literal: true

require "test_helper"

class TestInspectQuotable < Minitest::Test
  def test_it_quotes_array
    assert_equal("\"[1, 2, 3]\"", [1, 2, 3].in_quotes)
    assert_equal("\"[1, 2, 3]\"", [1, 2, 3].with_quotes)
  end

  def test_it_quotes_hash
    assert_equal("\"{:a=>1}\"", {a: 1}.in_quotes)
  end

  def test_it_quotes_nil
    assert_equal("\"nil\"", nil.in_quotes)
  end

  def test_it_quotes_boolean
    assert_equal("\"true\"", true.in_quotes)
    assert_equal("\"false\"", false.in_quotes)
  end

  def test_it_quotes_regexp
    assert_equal("\"/test/i\"", /test/i.in_quotes)
  end

  def test_it_quotes_numeric
    assert_equal("\"42\"", 42.in_quotes)
    assert_equal("\"3.14\"", 3.14.in_quotes)
  end

  def test_it_quotes_range
    assert_equal("\"1..5\"", (1..5).in_quotes)
  end
end

class TestStringQuotable < Minitest::Test
  def test_it_quotes_time
    time = Time.new(2025, 5, 3, 12, 34, 56, "+00:00")
    expected = "\"2025-05-03 12:34:56 +0000\""
    assert_equal(expected, time.in_quotes)
  end

  def test_it_quotes_date
    date = Date.new(2025, 5, 3)
    assert_equal("\"2025-05-03\"", date.in_quotes)
  end

  def test_it_quotes_datetime
    datetime = DateTime.new(2025, 5, 3, 12, 34, 56, "+00:00")
    expected = "\"2025-05-03T12:34:56+00:00\""
    assert_equal(expected, datetime.in_quotes)
  end
end
