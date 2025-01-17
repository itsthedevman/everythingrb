# frozen_string_literal: true

require "test_helper"

class TestHashToIstruct < Minitest::Test
  def test_it_converts_to_data
    input = {
      a: 1,
      b: nil,
      c: 2,
      d: nil,
      e: 3
    }

    object = input.to_istruct

    assert_kind_of(Data, object)

    assert_equal(1, object.a)
    assert_nil(object.b)
    assert_equal(2, object.c)
    assert_nil(object.d)
    assert_equal(3, object.e)
  end

  def test_it_recursively_convert_hash
    input = {
      a: {
        b: {
          c: 1
        }
      }
    }

    output = input.to_istruct

    assert_kind_of(Data, output.a)
    assert_kind_of(Data, output.a.b)
    assert_equal(1, output.a.b.c)
  end

  def test_it_recursively_convert_array
    input = {
      a: {
        b: [
          {c: 1},
          {d: 2}
        ]
      }
    }

    output = input.to_istruct

    assert_kind_of(Data, output.a)
    assert_kind_of(Array, output.a.b)

    first = output.a.b[0]
    assert_kind_of(Data, first)
    assert_equal(1, first.c)

    second = output.a.b[1]
    assert_kind_of(Data, second)
    assert_equal(2, second.d)
  end
end
