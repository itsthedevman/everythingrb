# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create(:test_regular) do |t|
  # I couldn't get extra_args to work
  t.test_globs = Dir.glob("test/**/test_*.rb").reject { |f| f.include?("active_support") }
end

Minitest::TestTask.create(:test_active_support) do |t|
  t.test_globs = ["test/**/test_*_active_support.rb"]
  t.test_prelude = "ENV[\"LOAD_ACTIVE_SUPPORT\"] = \"true\""
end

require "standard/rake"

task test: [:test_regular, :test_active_support]
task default: %i[test standard]
