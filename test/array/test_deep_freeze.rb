# frozen_string_literal: true

require "test_helper"

class TestArrayDeepFreeze < Minitest::Test
  def setup
    @object = [
      +"1",
      +"2",
      [+"1", +"2", +"3"],
      1,
      true,
      {key_1: +"value_1", key_2: [+"value_2"]}
    ].deep_freeze
  end

  def test_it_deeply_freezes
    assert(@object.frozen?)
    assert(@object[0].frozen?)
    assert(@object[1].frozen?)
    assert(@object[2].frozen?)
    assert(@object[2][0].frozen?)
    assert(@object[2][1].frozen?)
    assert(@object[2][3].frozen?)
    assert(@object[3].frozen?)
    assert(@object[4].frozen?)
    assert(@object[5].frozen?)
    assert(@object[5][:key_1].frozen?)
    assert(@object[5][:key_2].frozen?)
    assert(@object[5][:key_2][0].frozen?)
  end
end
