# frozen_string_literal: true

require "test_helper"

class TestStringParseJson < Minitest::Test
  def setup
    @input = {
      a: {
        b: [
          {c: 1},
          {d: 2}.to_json
        ]
      }
    }.to_json

    @output = @input.parse_json
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
    assert_nil("invalid_json".parse_json)
  end

  def test_it_symbolizes_keys_by_default
    result = '{"name": "Alice"}'.parse_json

    assert_equal({name: "Alice"}, result)
  end

  def test_it_can_disable_symbolized_keys
    result = '{"name": "Alice"}'.parse_json(symbolize_names: false)

    assert_equal({"name" => "Alice"}, result)
  end

  def test_it_passes_opts_to_json_parse
    result = '{"name": "Alice"}'.parse_json(symbolize_names: false, max_nesting: 1)

    assert_equal({"name" => "Alice"}, result)
  end
end
