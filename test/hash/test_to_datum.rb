# frozen_string_literal: true

require "test_helper"

class TestHashToDatum < Minitest::Test
  def test_it_converts_to_a_datum
    input = {a: 1, b: nil, c: 2}

    object = input.to_datum

    assert_kind_of(Datum, object)
    assert_equal(1, object.a)
    assert_nil(object.b)
    assert_equal(2, object.c)
  end

  def test_it_recursively_converts_hashes
    output = {a: {b: {c: 1}}}.to_datum

    assert_kind_of(Datum, output.a)
    assert_kind_of(Datum, output.a.b)
    assert_equal(1, output.a.b.c)
  end

  def test_it_recursively_converts_arrays
    output = {a: {b: [{c: 1}, {d: 2}]}}.to_datum

    assert_kind_of(Datum, output.a)
    assert_kind_of(Array, output.a.b)

    first = output.a.b[0]
    assert_kind_of(Datum, first)
    assert_equal(1, first.c)

    second = output.a.b[1]
    assert_equal(2, second.d)
  end

  def test_converted_datums_are_comparable
    assert_equal({a: 1, b: 2}.to_datum, {a: 1, b: 2}.to_datum)
  end
end
