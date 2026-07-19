# frozen_string_literal: true

require "test_helper"

class TestDatumNew < Minitest::Test
  def test_it_builds_an_immutable_object
    object = Datum.new(host: "localhost", port: 3000)

    assert_kind_of(Data, object)
    assert_kind_of(Datum, object)
    assert_equal("localhost", object.host)
    assert_equal(3000, object.port)
  end

  def test_it_leaves_nested_values_untouched
    object = Datum.new(name: "Bob", meta: {role: "admin"})

    assert_kind_of(Hash, object.meta)
    assert_equal({role: "admin"}, object.meta)
  end

  def test_it_symbolizes_string_keys
    object = Datum.new("host" => "localhost")

    assert_equal("localhost", object.host)
  end

  def test_it_builds_from_an_existing_hash
    object = Datum.new({a: 1, b: 2})

    assert_equal(1, object.a)
    assert_equal(2, object.b)
  end

  def test_it_handles_no_attributes
    object = Datum.new

    assert_kind_of(Datum, object)
    assert_empty(object.members)
  end
end
