# frozen_string_literal: true

require "test_helper"

class TestKernelMorph < Minitest::Test
  def test_it_morphs_the_value
    struct = {id: 1, name: "Foo"}.to_istruct

    result = struct.morph { |s| "id:#{s.id}, name:#{s.name}" }

    assert_equal("id:1, name:Foo", result)
  end
end
