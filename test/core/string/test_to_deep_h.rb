# frozen_string_literal: true

require "test_helper"

class TestStringToDeepH < Minitest::Test
  def setup
    @input = {
      a: {
        b: [
          {c: 1},
          {d: 2}.to_json
        ]
      }
    }.to_json

    @output = @input.to_deep_h
  end

  def test_it_recursively_converts
    assert_kind_of(String, @input)

    assert_equal(
      {
        a: {
          b: [
            {c: 1},
            {d: 2}
          ]
        }
      },
      @output
    )
  end
end
