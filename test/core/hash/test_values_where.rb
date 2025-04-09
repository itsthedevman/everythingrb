# frozen_string_literal: true

require "test_helper"

class TestHashValuesWhere < Minitest::Test
  def test_it_finds_all_hashes_by_key
    users = {
      alice: {name: "Alice", role: "admin"},
      bob: {name: "Bob", role: "user"},
      charlie: {name: "Charlie", role: "admin"}
    }

    assert_equal(
      [{name: "Alice", role: "admin"}, {name: "Charlie", role: "admin"}],
      users.values_where { |k, v| v[:role] == "admin" }
    )
  end

  def test_it_handles_finding_nothing
    assert_equal([], {}.values_where { |k, v| k })
  end
end
