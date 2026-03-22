# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("OpenStruct Extension Benchmarks")

# Test data
small_ostruct = OpenStruct.new(a: 1, b: 2, c: 3)
medium_ostruct = OpenStruct.new((1..20).each_with_object({}) { |i, h| h[:"attr#{i}"] = i })
ostruct_with_nil = OpenStruct.new(a: 1, b: nil, c: 3, d: nil, e: 5)
empty_ostruct = OpenStruct.new

# ============================================================================
# map / filter_map benchmarks
# ============================================================================

BenchmarkHelper.run("map - small OpenStruct (3 attributes)") do |x|
  x.report("map") { small_ostruct.map { |k, v| [k, v * 2] } }
end

BenchmarkHelper.run("map - medium OpenStruct (20 attributes)") do |x|
  x.report("map") { medium_ostruct.map { |k, v| [k, v * 2] } }
end

BenchmarkHelper.run("filter_map - with nils") do |x|
  x.report("filter_map") { ostruct_with_nil.filter_map { |k, v| v * 2 if v } }
end

# ============================================================================
# join_map benchmarks
# ============================================================================

BenchmarkHelper.run("join_map - small OpenStruct") do |x|
  x.report("join_map") { small_ostruct.join_map(", ") { |k, v| "#{k}=#{v}" } }
  x.report("join_map (no block)") { small_ostruct.join_map(", ") }
end

BenchmarkHelper.run("join_map - with nils") do |x|
  x.report("join_map (filtering nils)") { ostruct_with_nil.join_map(" ") { |k, v| "#{k}-#{v}" if v } }
end

# ============================================================================
# each (alias for each_pair)
# ============================================================================

BenchmarkHelper.run("each - small OpenStruct") do |x|
  x.report("each") do
    result = []
    small_ostruct.each { |k, v| result << [k, v] }
    result
  end
end

# ============================================================================
# to_ostruct (identity method)
# ============================================================================

BenchmarkHelper.run("to_ostruct (identity)") do |x|
  x.report("to_ostruct") { small_ostruct.to_ostruct }
end

# ============================================================================
# in_quotes benchmarks
# ============================================================================

BenchmarkHelper.run("in_quotes / with_quotes") do |x|
  x.report("small ostruct in_quotes") { small_ostruct.in_quotes }
  x.report("medium ostruct in_quotes") { medium_ostruct.in_quotes }
end

# ============================================================================
# ActiveSupport-only benchmarks
# ============================================================================

if BenchmarkHelper.active_support?
  BenchmarkHelper.run("blank? / present?") do |x|
    x.report("blank? (empty)") { empty_ostruct.blank? }
    x.report("blank? (non-empty)") { small_ostruct.blank? }
    x.report("present? (empty)") { empty_ostruct.present? }
    x.report("present? (non-empty)") { small_ostruct.present? }
  end
else
  puts "\n[SKIPPED] ActiveSupport benchmarks - run with LOAD_ACTIVE_SUPPORT=true"
end
