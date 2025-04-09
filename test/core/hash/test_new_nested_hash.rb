# frozen_string_literal: true

require "test_helper"

class TestHashNewNestedHash < Minitest::Test
  def test_it_works
    users = Hash.new_nested_hash
    users[:john][:role] = "admin"

    assert_equal({john: {role: "admin"}}, users)
  end

  def test_it_handles_multiple_levels
    stats = Hash.new_nested_hash
    (stats[:server][:region][:us_east][:errors] = []) << "Some Error"

    assert_equal(
      {server: {region: {us_east: {errors: ["Some Error"]}}}},
      stats
    )
  end
end
