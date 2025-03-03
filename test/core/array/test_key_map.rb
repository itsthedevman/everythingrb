# frozen_string_literal: true

require "test_helper"

class TestArrayKeyMap < Minitest::Test
  def test_it_maps_based_on_key
    assert_equal ["Alice", "Bob"],
      [{name: "Alice", age: 30}, {name: "Bob", age: 25}].key_map(:name)
  end
end
