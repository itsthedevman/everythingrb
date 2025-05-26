# frozen_string_literal: true

require "test_helper"

class TestReplaceKeyUnordered < Minitest::Test
  def test_it_renames_the_key
    hash = {key_1: 1, key_2: 2}
    new_hash = hash.rename_key_unordered(:key_1, :key_one)

    refute_same(hash, new_hash)
    assert_equal({key_1: 1, key_2: 2}, hash)

    # Order is not preserved
    assert_equal([:key_2, :key_one], new_hash.keys)
    assert_equal([2, 1], new_hash.values)
  end

  def test_it_renames_the_key_in_memory
    hash = {key_1: 1, key_2: 2}
    modified_hash = hash.rename_key_unordered!(:key_1, :key_one)

    assert_same(hash, modified_hash)

    # Order is not preserved
    assert_equal([:key_2, :key_one], hash.keys)
    assert_equal([2, 1], hash.values)
  end

  def test_it_can_change_the_type
    hash = {key_1: 1, key_2: 2}
    assert_equal({:key_2 => 2, "key_one" => 1}, hash.rename_key_unordered(:key_1, "key_one"))

    hash.rename_key_unordered!(:key_1, "key_one")
    assert_equal({:key_2 => 2, "key_one" => 1}, hash)
  end

  def test_it_does_not_add_non_existent_key
    hash = {baz: true}

    result = hash.rename_key_unordered(:foo, :bar)
    assert_equal({baz: true}, result)

    hash.rename_key_unordered!(:foo, :bar)
    assert_equal({baz: true}, hash)
  end
end
