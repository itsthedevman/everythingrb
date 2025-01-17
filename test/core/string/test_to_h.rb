# frozen_string_literal: true

require "test_helper"

class TestStringToH < Minitest::Test
  def setup
    @input = {
      a: {
        b: [
          {c: 1},
          {d: 2}.to_json
        ]
      }
    }.to_json

    @output = @input.to_h
  end

  def test_it_parses_json_shallow
    assert_kind_of(String, @input)

    assert_equal(
      {
        a: {
          b: [
            {c: 1},
            {d: 2}.to_json
          ]
        }
      },
      @output
    )
  end

  def test_it_returns_nil_invalid_json
    assert_nil("invalid_json".to_h)
  end
end
