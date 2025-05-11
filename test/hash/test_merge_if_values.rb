# frozen_string_literal: true

require "test_helper"

class TestHashMergeIfValues < Minitest::Test
  def setup
    @hash = {key_1: 1, key_2: 2, key_3: 3, key_4: 4}
  end

  def test_it_merges_conditionally_by_value
    input = {key_1: 3, key_2: 4, key_3: 5, key_4: 6}

    result = @hash.merge_if_values(input) { |v| v % 2 == 1 }

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, result)
  end

  def test_it_merges_conditionally_by_value_in_memory
    input = {key_1: 3, key_2: 4, key_3: 5, key_4: 6}

    @hash.merge_if_values!(input) { |v| v % 2 == 1 }

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, @hash)
  end

  def test_it_works_with_kwargs
    result = @hash.merge_if_values!(key_1: 3, key_2: 4, key_3: 5, key_4: 6) { |v| v % 2 == 1 }

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, result)
  end
end
