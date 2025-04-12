# frozen_string_literal: true

require "test_helper"

class TestDataToDeepH < Minitest::Test
  def test_it_deeply_converts_to_hash
    test_data = Data.define(:name, :metadata)
    data = test_data.new(
      name: "Alice",
      metadata: {
        profile: {
          role: "admin",
          permissions: {read: true, write: true}.to_json
        }.to_json
      }
    )

    result = data.to_deep_h

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

  def test_it_handles_nested_data_objects
    address_data = Data.define(:city, :country)
    person_data = Data.define(:name, :address, :roles)

    person = person_data.new(
      name: "Bob",
      address: address_data.new(city: "New York", country: "USA"),
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
