# frozen_string_literal: true

require "test_helper"

class TestReplaceKeys < Minitest::Test
  def test_it_renames_the_keys
    hash = {key_1: 1, key_2: 2}
    new_hash = hash.rename_keys(key_1: :key_one, key_2: :key_two)

    refute_same(hash, new_hash)
    assert_equal({key_1: 1, key_2: 2}, hash)

    # Order matters!
    assert_equal([:key_one, :key_two], new_hash.keys)
    assert_equal([1, 2], new_hash.values)
  end

  def test_it_renames_the_key_in_memory
    hash = {key_1: 1, key_2: 2}
    modified_hash = hash.rename_keys!(key_1: :key_one, key_2: :key_two)

    assert_same(hash, modified_hash)

    # Order matters!
    assert_equal([:key_one, :key_two], hash.keys)
    assert_equal([1, 2], hash.values)
  end

  def test_it_can_change_the_type
    hash = {key_1: 1, key_2: 2}
    assert_equal({"key_one" => 1, "key_two" => 2}, hash.rename_keys(key_1: "key_one", key_2: "key_two"))

    hash.rename_keys!(key_1: "key_one", key_2: "key_two")
    assert_equal({"key_one" => 1, "key_two" => 2}, hash)
  end

  def test_it_does_not_add_non_existent_key
    hash = {baz: true}

    result = hash.rename_keys(foo: :bar)
    assert_equal({baz: true}, result)

    hash.rename_keys!(foo: :bar)
    assert_equal({baz: true}, hash)
  end
end
