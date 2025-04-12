# frozen_string_literal: true

require "test_helper"

class TestArrayToOrSentence < Minitest::Test
  def it_works_with_multiple_items
    result = ["apples", "oranges", "bananas"].to_or_sentence
    assert_equal("apples, oranges, or bananas", result)
  end

  def it_works_with_two_items
    result = ["apples", "oranges"].to_or_sentence
    assert_equal("apples or oranges", result)
  end

  def it_supports_overwriting_options
    result = ["apples", "oranges", "bananas"].to_or_sentence(last_word_connector: " or ")
    assert_equal("apples, oranges or bananas", result)
  end
end
