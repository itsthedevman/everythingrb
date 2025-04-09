# frozen_string_literal: true

require "test_helper"

class TestEnumerableGroupByKey < Minitest::Test
  def setup
    @input = [
      {
        name: "Alice",
        department: {name: "Sales"},
        role: "user"
      },
      {
        name: "Bob",
        department: {name: "IT"},
        role: "admin"
      },
      {
        name: "Charlie",
        department: {name: "Support"},
        role: "user"
      }
    ]
  end

  def test_it_groups_by_single_key
    assert_equal(
      {
        "Alice" => [@input[0]],
        "Bob" => [@input[1]],
        "Charlie" => [@input[2]]
      },
      @input.group_by_key(:name)
    )

    assert_equal(
      {
        "user" => [
          @input[0],
          @input[2]
        ],
        "admin" => [
          @input[1]
        ]
      },
      @input.group_by_key(:role)
    )
  end

  def test_it_groups_by_nested
    assert_equal(
      {
        "Sales" => [@input[0]],
        "IT" => [@input[1]],
        "Support" => [@input[2]]
      },
      @input.group_by_key(:department, :name)
    )
  end

  def test_it_supports_a_block
    assert_equal(
      {
        "selas" => [@input[0]],
        "ti" => [@input[1]],
        "troppus" => [@input[2]]
      },
      @input.group_by_key(:department, :name) { |name| name.downcase.reverse }
    )
  end

  def test_it_handles_non_hashes
    @input += [1, "foo", false]

    assert_equal(
      {
        "Alice" => [@input[0]],
        "Bob" => [@input[1]],
        "Charlie" => [@input[2]],
        nil => [1, "foo", false]
      },
      @input.group_by_key(:name)
    )
  end
end
