# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("Array Extension Benchmarks")

# Test data
small_array = (1..10).to_a
medium_array = (1..100).to_a
large_array = (1..1000).to_a

small_hashes = [{name: "Alice", age: 30}, {name: "Bob", age: 25}, {name: "Charlie", age: 35}]
medium_hashes = (1..100).map { |i| {name: "User#{i}", age: 20 + (i % 50)} }
large_hashes = (1..1000).map { |i| {name: "User#{i}", age: 20 + (i % 50)} }

nested_hashes = [
  {user: {profile: {name: "Alice"}}},
  {user: {profile: {name: "Bob"}}},
  {user: {profile: {name: "Charlie"}}}
]

array_with_nils_prefix = [nil, nil, nil, 1, 2, 3, nil, 4, 5]
array_with_nils_suffix = [1, 2, 3, nil, 4, 5, nil, nil, nil]
array_with_nils_both = [nil, nil, 1, 2, nil, 3, 4, nil, nil]

# ============================================================================
# join_map benchmarks
# ============================================================================

BenchmarkHelper.run("join_map - small array (10 elements)") do |x|
  x.report("join_map") { small_array.join_map(", ") { |n| n.to_s if n.even? } }
  x.report("join_map(with_index)") { small_array.join_map(", ", with_index: true) { |n, i| "#{i}:#{n}" } }
end

BenchmarkHelper.run("join_map - medium array (100 elements)") do |x|
  x.report("join_map") { medium_array.join_map(", ") { |n| n.to_s if n.even? } }
  x.report("join_map(with_index)") { medium_array.join_map(", ", with_index: true) { |n, i| "#{i}:#{n}" } }
end

BenchmarkHelper.run("join_map - large array (1000 elements)") do |x|
  x.report("join_map") { large_array.join_map(", ") { |n| n.to_s if n.even? } }
  x.report("join_map(with_index)") { large_array.join_map(", ", with_index: true) { |n, i| "#{i}:#{n}" } }
end

# ============================================================================
# key_map benchmarks
# ============================================================================

BenchmarkHelper.run("key_map - small array of hashes (3 elements)") do |x|
  x.report("key_map") { small_hashes.key_map(:name) }
end

BenchmarkHelper.run("key_map - medium array of hashes (100 elements)") do |x|
  x.report("key_map") { medium_hashes.key_map(:name) }
end

BenchmarkHelper.run("key_map - large array of hashes (1000 elements)") do |x|
  x.report("key_map") { large_hashes.key_map(:name) }
end

# ============================================================================
# dig_map benchmarks
# ============================================================================

BenchmarkHelper.run("dig_map - nested hashes") do |x|
  x.report("dig_map(:user, :profile, :name)") { nested_hashes.dig_map(:user, :profile, :name) }
end

# ============================================================================
# compact_prefix / compact_suffix / trim_nils benchmarks
# ============================================================================

BenchmarkHelper.run("nil trimming operations") do |x|
  x.report("compact_prefix") { array_with_nils_prefix.compact_prefix }
  x.report("compact_suffix") { array_with_nils_suffix.compact_suffix }
  x.report("trim_nils") { array_with_nils_both.trim_nils }
end

# ============================================================================
# in_quotes benchmarks
# ============================================================================

BenchmarkHelper.run("in_quotes / with_quotes") do |x|
  x.report("small array in_quotes") { small_array.in_quotes }
  x.report("medium array in_quotes") { medium_array.in_quotes }
end

# ============================================================================
# ActiveSupport-only benchmarks
# ============================================================================

if BenchmarkHelper.active_support?
  array_with_blanks = ["", nil, "foo", "", "bar", nil, ""]
  words = %w[red blue green]

  BenchmarkHelper.run("compact_blank_prefix / compact_blank_suffix / trim_blanks") do |x|
    x.report("compact_blank_prefix") { array_with_blanks.compact_blank_prefix }
    x.report("compact_blank_suffix") { array_with_blanks.compact_blank_suffix }
    x.report("trim_blanks") { array_with_blanks.trim_blanks }
  end

  BenchmarkHelper.run("to_or_sentence") do |x|
    x.report("to_or_sentence") { words.to_or_sentence }
    x.report("to_or_sentence(custom)") { words.to_or_sentence(locale: :en) }
  end
else
  puts "\n[SKIPPED] ActiveSupport benchmarks - run with LOAD_ACTIVE_SUPPORT=true"
end
