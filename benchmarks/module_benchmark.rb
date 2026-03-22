# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("Module Extension Benchmarks")

# Define test classes with attr_predicate
class UserWithPredicate
  attr_accessor :admin, :active, :verified
  attr_predicate :admin, :active, :verified
end

class TaskWithFrom
  attr_accessor :started_at, :stopped_at
  attr_predicate :started, from: :@started_at
  attr_predicate :finished, from: :@stopped_at
end

class JobWithMethodFrom
  attr_accessor :error_messages
  attr_predicate :errored, from: :error_messages
end

PersonStruct = Struct.new(:active, :name)
PersonStruct.attr_predicate(:active)

# Test data
user_true = UserWithPredicate.new.tap do |u|
  u.admin = true
  u.active = true
  u.verified = true
end

user_false = UserWithPredicate.new.tap do |u|
  u.admin = false
  u.active = nil
  u.verified = ""
end

task_started = TaskWithFrom.new.tap { |t| t.started_at = Time.now }
task_not_started = TaskWithFrom.new

job_errored = JobWithMethodFrom.new.tap { |j| j.error_messages = ["Error 1", "Error 2"] }
job_clean = JobWithMethodFrom.new.tap { |j| j.error_messages = [] }

person_active = PersonStruct.new(true, "Alice")
person_inactive = PersonStruct.new(false, "Bob")

# ============================================================================
# attr_predicate - basic usage benchmarks
# ============================================================================

BenchmarkHelper.run("attr_predicate - truthy values") do |x|
  x.report("admin? (true)") { user_true.admin? }
  x.report("active? (true)") { user_true.active? }
  x.report("verified? (true)") { user_true.verified? }
end

BenchmarkHelper.run("attr_predicate - falsy values") do |x|
  x.report("admin? (false)") { user_false.admin? }
  x.report("active? (nil)") { user_false.active? }
  x.report("verified? (empty string)") { user_false.verified? }
end

# ============================================================================
# attr_predicate - with from: option (ivar)
# ============================================================================

BenchmarkHelper.run("attr_predicate with from: @ivar") do |x|
  x.report("started? (has value)") { task_started.started? }
  x.report("started? (nil)") { task_not_started.started? }
end

# ============================================================================
# attr_predicate - with from: option (method)
# ============================================================================

BenchmarkHelper.run("attr_predicate with from: method") do |x|
  x.report("errored? (has errors)") { job_errored.errored? }
  x.report("errored? (empty array)") { job_clean.errored? }
end

# ============================================================================
# attr_predicate - with Struct
# ============================================================================

BenchmarkHelper.run("attr_predicate on Struct") do |x|
  x.report("active? (true)") { person_active.active? }
  x.report("active? (false)") { person_inactive.active? }
end

# ============================================================================
# attr_predicate definition time (one-time cost)
# ============================================================================

BenchmarkHelper.run("attr_predicate definition time") do |x|
  x.report("define single predicate") do
    klass = Class.new { attr_accessor :test }
    klass.attr_predicate(:test)
  end

  x.report("define multiple predicates") do
    klass = Class.new { attr_accessor :a, :b, :c }
    klass.attr_predicate(:a, :b, :c)
  end
end
