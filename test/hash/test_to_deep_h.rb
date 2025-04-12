# frozen_string_literal: true

require "test_helper"
require "date"

class TestHashToDeepH < Minitest::Test
  def test_it_converts_data_objects
    result = {
      name: "Alice",
      metadata: Data.define(:source).new(source: "API")
    }.to_deep_h

    assert_equal({name: "Alice", metadata: {source: "API"}}, result)
  end

  def test_it_parses_nested_json
    result = {
      profile: {
        role: "admin",
        metadata: {nickname: "foobar"}.to_json
      }.to_json
    }.to_deep_h

    assert_equal(
      {
        profile: {
          role: "admin",
          metadata: {nickname: "foobar"}
        }
      },
      result
    )
  end

  def test_it_handles_mixed_types
    result = {
      metadata: {created_at: Date.today.to_s},
      config: OpenStruct.new(api_key: "secret"),
      users: [
        Data.define(:name).new(name: "Bob"),
        {role: "admin"}
      ]
    }.to_deep_h

    assert_equal(
      {
        metadata: {created_at: Date.today.to_s},
        config: {api_key: "secret"},
        users: [
          {name: "Bob"},
          {role: "admin"}
        ]
      },
      result
    )
  end
end
