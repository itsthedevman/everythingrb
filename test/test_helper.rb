# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "active_support"
require "active_support/core_ext"

require "everythingrb"

require "minitest/autorun"

Minitest::Test.make_my_diffs_pretty!
