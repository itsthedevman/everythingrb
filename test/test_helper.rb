# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

if ENV["LOAD_ACTIVE_SUPPORT"] == "true"
  require "active_support"
  require "active_support/core_ext"
end

require "pry"
require "everythingrb"

require "minitest/autorun"

Minitest::Test.make_my_diffs_pretty!
