# frozen_string_literal: true

require "test_helper"
require "date"

class TestArrayToDeepH < Minitest::Test
  def test_it_handles_mixed_types
    result = [
      {name: "Alice", roles: ["admin"]},
      OpenStruct.new(name: "Bob", active: true),
      Data.define(:name).new(name: "Carol")
    ].to_deep_h

    assert_equal(
      [
        {name: "Alice", roles: ["admin"]},
        {name: "Bob", active: true},
        {name: "Carol"}
      ],
      result
    )
  end

  def test_it_converts_nested_json
    result = [
      {profile: {level: "expert"}.to_json},
      [OpenStruct.new(id: 1), OpenStruct.new(id: 2)],
      [1, true, [2.0]]
    ].to_deep_h

    assert_equal(
      [
        {profile: {level: "expert"}},
        [{id: 1}, {id: 2}],
        [1, true, [2.0]]
      ],
      result
    )
  end
end
