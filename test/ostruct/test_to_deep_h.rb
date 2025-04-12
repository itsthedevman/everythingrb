# frozen_string_literal: true

require "test_helper"

class TestOpenStructToDeepH < Minitest::Test
  def test_it_deeply_converts_to_hash
    struct = OpenStruct.new(
      name: "Alice",
      metadata: {
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

  def test_it_handles_nested_openstructs
    address = OpenStruct.new(city: "New York", country: "USA")
    person = OpenStruct.new(
      name: "Bob",
      address: address,
      roles: ["admin", "user"]
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
