# frozen_string_literal: true

require "test_helper"

class TestHashMergeCompact < Minitest::Test
  def setup
    @hash = {key_1: 1, key_2: 2, key_3: 3, key_4: 4}
  end

  def test_it_merges_by_non_nil_values
    input = {key_1: nil, key_2: 4, key_3: nil, key_4: 6}

    result = @hash.merge_compact(input)

    assert_equal({key_1: 1, key_2: 4, key_3: 3, key_4: 6}, result)
  end

  def test_it_merges_by_non_nil_values_in_memory
    input = {key_1: 3, key_2: nil, key_3: 5, key_4: nil}

    @hash.merge_compact!(input)

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, @hash)
  end

  def test_it_works_with_kwargs
    @hash.merge_compact!(key_1: 3, key_2: nil, key_3: 5, key_4: nil)

    assert_equal({key_1: 3, key_2: 2, key_3: 5, key_4: 4}, @hash)
  end
end
