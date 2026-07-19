# frozen_string_literal: true

require "test_helper"

class TestHashToIstruct < Minitest::Test
  def test_it_delegates_to_to_datum_with_a_deprecation_warning
    result = nil

    out, err = capture_io do
      result = {a: {b: 1}}.to_istruct
    end

    assert_match(/deprecated/i, "#{out}#{err}")
    assert_kind_of(Datum, result)
    assert_equal(1, result.a.b)
  end
end
