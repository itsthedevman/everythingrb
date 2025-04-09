# frozen_string_literal: true

require "test_helper"

class TestHashValueWhere < Minitest::Test
  def test_it_finds_the_hash_by_key
    users = {
      alice: {name: "Alice", role: "admin"},
      bob: {name: "Bob", role: "user"},
      charlie: {name: "Charlie", role: "admin"}
    }

    assert_equal(
      {name: "Alice", role: "admin"},
      users.value_where { |k, v| v[:role] == "admin" }
    )
  end

  def test_it_handles_if_it_finds_nothing
    assert_nil(nil, {}.value_where { |k, v| k })
  end
end
