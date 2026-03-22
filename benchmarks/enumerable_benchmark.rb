# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("Enumerable Extension Benchmarks")

# Test data - using Range as an Enumerable that isn't Array
small_range = 1..10
medium_range = 1..100
large_range = 1..1000

users = [
  {name: "Alice", role: "admin"},
  {name: "Bob", role: "user"},
  {name: "Charlie", role: "admin"},
  {name: "Diana", role: "user"},
  {name: "Eve", role: "moderator"}
]

nested_data = [
  {department: {name: "Sales"}, employee: "Alice"},
  {department: {name: "IT"}, employee: "Bob"},
  {department: {name: "Sales"}, employee: "Charlie"},
  {department: {name: "HR"}, employee: "Diana"},
  {department: {name: "IT"}, employee: "Eve"}
]

large_users = (1..1000).map { |i| {name: "User#{i}", role: %w[admin user moderator][i % 3]} }

# ============================================================================
# join_map benchmarks (on Range)
# ============================================================================

BenchmarkHelper.run("join_map - small range (1..10)") do |x|
  x.report("join_map") { small_range.join_map(" | ") { |n| "num#{n}" if n.even? } }
  x.report("join_map(with_index)") { small_range.join_map(", ", with_index: true) { |n, i| "#{i}:#{n}" } }
end

BenchmarkHelper.run("join_map - medium range (1..100)") do |x|
  x.report("join_map") { medium_range.join_map(" | ") { |n| "num#{n}" if n.even? } }
end

BenchmarkHelper.run("join_map - large range (1..1000)") do |x|
  x.report("join_map") { large_range.join_map(" | ") { |n| "num#{n}" if n.even? } }
end

# ============================================================================
# group_by_key benchmarks
# ============================================================================

BenchmarkHelper.run("group_by_key - single key") do |x|
  x.report("group_by_key(:role)") { users.group_by_key(:role) }
end

BenchmarkHelper.run("group_by_key - nested keys") do |x|
  x.report("group_by_key(:department, :name)") { nested_data.group_by_key(:department, :name) }
end

BenchmarkHelper.run("group_by_key - with block transformation") do |x|
  x.report("group_by_key with upcase") { users.group_by_key(:role) { |role| role.upcase } }
end

BenchmarkHelper.run("group_by_key - large dataset (1000 elements)") do |x|
  x.report("group_by_key(:role)") { large_users.group_by_key(:role) }
end

# ============================================================================
# Set as Enumerable
# ============================================================================

small_set = Set.new(1..10)
medium_set = Set.new(1..100)

BenchmarkHelper.run("join_map - Set (10 elements)") do |x|
  x.report("join_map") { small_set.join_map(", ") { |n| "item#{n}" if n.odd? } }
end

BenchmarkHelper.run("join_map - Set (100 elements)") do |x|
  x.report("join_map") { medium_set.join_map(", ") { |n| "item#{n}" if n.odd? } }
end
