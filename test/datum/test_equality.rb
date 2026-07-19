# frozen_string_literal: true

require "test_helper"

class TestDatumEquality < Minitest::Test
  def test_same_attributes_are_equal
    assert_equal(Datum.new(a: 1, b: 2), Datum.new(a: 1, b: 2))
  end

  def test_different_attributes_are_not_equal
    refute_equal(Datum.new(a: 1), Datum.new(a: 2))
    refute_equal(Datum.new(a: 1), Datum.new(a: 1, b: 2))
  end

  def test_it_is_not_equal_to_a_plain_hash
    refute_equal({a: 1}, Datum.new(a: 1))
    refute_equal(Datum.new(a: 1), {a: 1})
  end

  def test_equal_datums_share_a_hash_code
    assert_equal(Datum.new(a: 1).hash, Datum.new(a: 1).hash)
  end

  def test_it_works_as_a_hash_key
    lookup = {Datum.new(id: 1) => "found"}

    assert_equal("found", lookup[Datum.new(id: 1)])
  end

  def test_it_dedupes_in_a_set
    set = Set.new([Datum.new(a: 1), Datum.new(a: 1), Datum.new(a: 2)])

    assert_equal(2, set.size)
  end

  def test_nested_datums_compare_structurally
    left = {user: {name: "Bob"}}.to_datum
    right = {user: {name: "Bob"}}.to_datum

    assert_equal(left, right)
  end
end
