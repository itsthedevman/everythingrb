# frozen_string_literal: true

require "test_helper"

class TestArrayDigMap < Minitest::Test
  def test_it_maps_based_on_key
    assert_equal(
      ["Alice", "Bob"],
      [
        {user: {profile: {name: "Alice"}}},
        {user: {profile: {name: "Bob"}}}
      ].dig_map(:user, :profile, :name)
    )
  end
end
