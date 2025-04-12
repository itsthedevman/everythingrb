# frozen_string_literal: true

require "test_helper"

class TestStructToDeepH < Minitest::Test
  def test_it_deeply_converts_to_hash
    test_struct = Struct.new(:name, :metadata)
    struct = test_struct.new(
      "Alice",
      {
        profile: {
          role: "admin",
          permissions: {read: true, write: true}.to_json
        }.to_json
      }
    )

    result = struct.to_deep_h

    assert_equal(
      {
        name: "Alice",
        metadata: {
          profile: {
            role: "admin",
            permissions: {
              read: true,
              write: true
            }
          }
        }
      },
      result
    )
  end

  def test_it_handles_nested_structs
    address_struct = Struct.new(:city, :country)
    person_struct = Struct.new(:name, :address, :roles)

    person = person_struct.new(
      "Bob",
      address_struct.new("New York", "USA"),
      ["admin", "user"]
    )

    result = person.to_deep_h

    assert_equal(
      {
        name: "Bob",
        address: {
          city: "New York",
          country: "USA"
        },
        roles: ["admin", "user"]
      },
      result
    )
  end
end
