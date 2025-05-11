# frozen_string_literal: true

require "test_helper"

class TestHashMergeIf < Minitest::Test
  def setup
    @hash = {key_1: 1, key_2: 2, key_3: 3, key_4: 4}
  end

  def test_it_merges_conditionally_by_key
    input = {key_1: 3, key_2: 4, key_3: 5, key_4: 6}

    result = @hash.merge_if(input) { |k, _v| k.to_s.sub("key_", "").to_i % 2 == 0 }

    assert_equal({key_1: 1, key_2: 4, key_3: 3, key_4: 6}, result)
  end

  def test_it_merges_conditionally_by_value
    input = {key_1: 3, key_2: 4, key_3: 5, key_4: 6}

    result = @hash.merge_if(input) { |_k, v| v % 2 == 1 }

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, result)
  end

  def test_it_merges_conditionally_by_key_in_memory
    input = {key_1: 3, key_2: 4, key_3: 5, key_4: 6}

    @hash.merge_if!(input) { |k, _v| k.to_s.sub("key_", "").to_i % 2 == 0 }

    assert_equal({key_1: 1, key_2: 4, key_3: 3, key_4: 6}, @hash)
  end

  def test_it_merges_conditionally_by_value_in_memory
    input = {key_1: 3, key_2: 4, key_3: 5, key_4: 6}

    @hash.merge_if!(input) { |_k, v| v % 2 == 1 }

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, @hash)
  end

  def test_it_works_with_kwargs
    result = @hash.merge_if(key_1: 3, key_2: 4, key_3: 5, key_4: 6) { |_k, v| v % 2 == 1 }

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, result)
  end
end
