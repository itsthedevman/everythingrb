# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("Hash Extension Benchmarks")

# Test data
small_hash = {a: 1, b: 2, c: 3}
medium_hash = (1..100).each_with_object({}) { |i, h| h[:"key#{i}"] = i }

nested_hash = {
  user: {
    profile: {name: "Alice", age: 30},
    settings: {theme: "dark", notifications: true}
  },
  meta: {created_at: "2024-01-01"}
}

users_hash = {
  alice: {name: "Alice", role: "admin"},
  bob: {name: "Bob", role: "user"},
  charlie: {name: "Charlie", role: "admin"}
}

# ============================================================================
# join_map benchmarks
# ============================================================================

BenchmarkHelper.run("join_map - small hash (3 keys)") do |x|
  x.report("join_map") { small_hash.join_map(", ") { |k, v| "#{k}=#{v}" } }
  x.report("join_map(with_index)") { small_hash.join_map(", ", with_index: true) { |(k, v), i| "#{i}:#{k}=#{v}" } }
end

BenchmarkHelper.run("join_map - medium hash (100 keys)") do |x|
  x.report("join_map") { medium_hash.join_map(", ") { |k, v| "#{k}=#{v}" } }
end

# ============================================================================
# to_struct / to_ostruct / to_istruct benchmarks
# ============================================================================

BenchmarkHelper.run("to_struct - small hash") do |x|
  x.report("to_struct") { small_hash.to_struct }
end

BenchmarkHelper.run("to_ostruct - small hash") do |x|
  x.report("to_ostruct") { small_hash.to_ostruct }
end

BenchmarkHelper.run("to_istruct - small hash") do |x|
  x.report("to_istruct") { small_hash.to_istruct }
end

BenchmarkHelper.run("structure conversion - nested hash") do |x|
  x.report("to_struct") { nested_hash.to_struct }
  x.report("to_ostruct") { nested_hash.to_ostruct }
  x.report("to_istruct") { nested_hash.to_istruct }
end

# ============================================================================
# transform_values with_key benchmarks
# ============================================================================

BenchmarkHelper.run("transform_values - small hash") do |x|
  x.report("transform_values") { small_hash.transform_values { |v| v * 2 } }
  x.report("transform_values(with_key)") { small_hash.transform_values(with_key: true) { |v, k| "#{k}:#{v * 2}" } }
end

BenchmarkHelper.run("transform_values - medium hash") do |x|
  x.report("transform_values") { medium_hash.transform_values { |v| v * 2 } }
  x.report("transform_values(with_key)") { medium_hash.transform_values(with_key: true) { |v, k| "#{k}:#{v * 2}" } }
end

# ============================================================================
# transform / transform! benchmarks
# ============================================================================

BenchmarkHelper.run("transform - small hash") do |x|
  x.report("transform") { small_hash.transform { |k, v| [:"new_#{k}", v * 2] } }
end

BenchmarkHelper.run("transform - medium hash") do |x|
  x.report("transform") { medium_hash.transform { |k, v| [:"new_#{k}", v * 2] } }
end

# ============================================================================
# find_value / select_values benchmarks
# ============================================================================

BenchmarkHelper.run("find_value / select_values") do |x|
  x.report("find_value") { users_hash.find_value { |_k, v| v[:role] == "admin" } }
  x.report("select_values") { users_hash.select_values { |_k, v| v[:role] == "admin" } }
end

# ============================================================================
# rename_key / rename_keys benchmarks
# ============================================================================

BenchmarkHelper.run("rename_key - small hash") do |x|
  x.report("rename_key (ordered)") { small_hash.rename_key(:b, :middle) }
  x.report("rename_key_unordered") { small_hash.rename_key_unordered(:b, :middle) }
end

BenchmarkHelper.run("rename_keys - small hash") do |x|
  x.report("rename_keys") { small_hash.rename_keys(a: :first, c: :last) }
end

BenchmarkHelper.run("rename_key - medium hash") do |x|
  x.report("rename_key (ordered)") { medium_hash.rename_key(:key50, :middle) }
  x.report("rename_key_unordered") { medium_hash.rename_key_unordered(:key50, :middle) }
end

# ============================================================================
# merge_if / merge_if_values benchmarks
# ============================================================================

other_hash = {d: 4, e: 5, f: nil}

BenchmarkHelper.run("merge_if / merge_if_values") do |x|
  x.report("merge_if") { small_hash.merge_if(other_hash) { |_k, v| v&.even? } }
  x.report("merge_if_values") { small_hash.merge_if_values(other_hash) { |v| v&.odd? } }
end

# ============================================================================
# compact_merge benchmarks
# ============================================================================

hash_with_nils = {a: 1, b: nil, c: 3, d: nil}

BenchmarkHelper.run("compact_merge") do |x|
  x.report("compact_merge") { small_hash.compact_merge(hash_with_nils) }
end

# ============================================================================
# in_quotes benchmarks
# ============================================================================

BenchmarkHelper.run("in_quotes / with_quotes") do |x|
  x.report("small hash in_quotes") { small_hash.in_quotes }
  x.report("nested hash in_quotes") { nested_hash.in_quotes }
end

# ============================================================================
# ActiveSupport-only benchmarks
# ============================================================================

if BenchmarkHelper.active_support?
  BenchmarkHelper.run("deep_transform_values(with_key)") do |x|
    x.report("deep_transform_values") { nested_hash.deep_transform_values { |v| v.to_s.upcase } }
    x.report("deep_transform_values(with_key)") { nested_hash.deep_transform_values(with_key: true) { |v, k| "#{k}:#{v}" } }
  end

  hash_with_blanks = {a: 1, b: "", c: [], d: "present"}

  BenchmarkHelper.run("compact_blank_merge") do |x|
    x.report("compact_blank_merge") { small_hash.compact_blank_merge(hash_with_blanks) }
  end
else
  puts "\n[SKIPPED] ActiveSupport benchmarks - run with LOAD_ACTIVE_SUPPORT=true"
end
