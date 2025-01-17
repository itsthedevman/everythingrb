# frozen_string_literal: true

require "test_helper"

class TestStringToOstruct < Minitest::Test
  def setup
    @input = {
      a: {
        b: [
          {c: 1},
          {d: 2}.to_json
        ]
      }
    }.to_json

    @output = @input.to_ostruct
  end

  def test_it_parses_json_shallow_and_converts
    assert_kind_of(String, @input)
    assert_kind_of(OpenStruct, @output)

    assert_kind_of(OpenStruct, @output.a.b[0])
    assert_equal(1, @output.a.b[0].c)
    assert_kind_of(String, @output.a.b[1])
  end

  def test_it_returns_nil_invalid_json
    assert_nil("invalid_json".to_ostruct)
  end
end
