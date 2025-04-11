# frozen_string_literal: true

require "test_helper"

class TestReplaceKeys < Minitest::Test
  def test_it_replaces_the_keys
    hash = {key_1: 1, key_2: 2}
    new_hash = hash.replace_keys(key_1: :key_one, key_2: :key_two)

    refute_same(hash, new_hash)
    assert_equal({key_1: 1, key_2: 2}, hash)
    assert_equal({key_one: 1, key_two: 2}, new_hash)
  end

  def test_it_replaces_the_key_in_memory
    hash = {key_1: 1, key_2: 2}
    modified_hash = hash.replace_keys!(key_1: :key_one, key_2: :key_two)

    assert_same(hash, modified_hash)
    assert_equal({key_one: 1, key_two: 2}, hash)
  end

  def test_it_replaces_keys_in_order
    hash = {a: 1, b: 2, c: 3}
    new_hash = hash.replace_keys(a: :b, b: :c)

    # Order matters {b: 1, c:2}
    assert_equal([:b, :c], new_hash.keys)
    assert_equal([1, 3], new_hash.values)
  end
end
