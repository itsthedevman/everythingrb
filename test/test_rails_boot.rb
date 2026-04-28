# frozen_string_literal: true

require "test_helper"
require "shellwords"

# Verifies the documented install path ("just add gem \"everythingrb\" to
# your Gemfile") produces a Rails app that boots cleanly in both dev and
# prod modes. Spawns a subprocess per scenario because Rails::Application
# is a singleton and we want a clean Rails world per test.
class TestRailsBoot < Minitest::Test
  FIXTURE = File.expand_path("fixtures/rails_boot.rb", __dir__)

  def test_boots_in_prod_with_eager_load
    out, status = run_fixture(eager_load: true)
    assert status.success?, "prod boot failed (eager_load=true):\n#{out}"
    assert_match(/\Aok$/, out.strip)
  end

  def test_boots_in_dev_without_eager_load
    out, status = run_fixture(eager_load: false)
    assert status.success?, "dev boot failed (eager_load=false):\n#{out}"
    assert_match(/\Aok$/, out.strip)
  end

  private

  def run_fixture(eager_load:)
    cmd = "bundle exec ruby #{Shellwords.escape(FIXTURE)} 2>&1"
    out = IO.popen({"EAGER_LOAD" => eager_load.to_s}, cmd, &:read)
    [out, $?]
  end
end
