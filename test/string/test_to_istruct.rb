# frozen_string_literal: true

require "test_helper"

class TestStringToIstruct < Minitest::Test
  def test_it_delegates_to_to_datum_with_a_deprecation_warning
    result = nil

    out, err = capture_io do
      result = '{"name": "Alice"}'.to_istruct
    end

    assert_match(/deprecated/i, "#{out}#{err}")
    assert_kind_of(Datum, result)
    assert_equal("Alice", result.name)
  end
end
