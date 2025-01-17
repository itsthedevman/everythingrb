# frozen_string_literal: true

require "test_helper"

class TestEverythingrb < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Everythingrb::VERSION
  end
end
