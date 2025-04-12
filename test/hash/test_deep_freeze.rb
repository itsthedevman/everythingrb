# frozen_string_literal: true

require "test_helper"

class TestHashDeepFreeze < Minitest::Test
  def setup
    @object = {
      key_1: +"1",
      key_2: +"2",
      key_3: [+"1", +"2", +"3"],
      key_4: 1,
      key_5: true,
      key_6: {key_1: +"value_1", key_2: [+"value_2"]}
    }.deep_freeze
  end

  def test_it_deeply_freezes
    assert(@object.frozen?)
    assert(@object[:key_1].frozen?)
    assert(@object[:key_2].frozen?)
    assert(@object[:key_3].frozen?)
    assert(@object[:key_3][0].frozen?)
    assert(@object[:key_3][1].frozen?)
    assert(@object[:key_3][3].frozen?)
    assert(@object[:key_4].frozen?)
    assert(@object[:key_5].frozen?)
    assert(@object[:key_6].frozen?)
    assert(@object[:key_6][:key_1].frozen?)
    assert(@object[:key_6][:key_2].frozen?)
    assert(@object[:key_6][:key_2][0].frozen?)
  end
end
