# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("Kernel Extension Benchmarks")

# Test data
number = 42
string = "hello"
hash = {name: "Alice", age: 30}
array = [1, 2, 3, 4, 5]

# ============================================================================
# morph benchmarks (alias for then/yield_self)
# ============================================================================

BenchmarkHelper.run("morph - simple transformation") do |x|
  x.report("morph { * 2 }") { number.morph { |n| n * 2 } }
  x.report("morph { upcase }") { string.morph { |s| s.upcase } }
end

BenchmarkHelper.run("morph - chained transformations") do |x|
  x.report("morph chain (2 steps)") do
    number.morph { |n| n * 2 }.morph { |n| n.to_s }
  end

  x.report("morph chain (3 steps)") do
    string.morph { |s| s.upcase }.morph { |s| s.reverse }.morph { |s| s.chars }
  end
end

BenchmarkHelper.run("morph - with hash") do |x|
  x.report("morph hash transform") do
    hash.morph { |h| h.transform_values(&:to_s) }
  end
end

BenchmarkHelper.run("morph - with array") do |x|
  x.report("morph array transform") do
    array.morph { |a| a.map { |n| n * 2 } }.morph { |a| a.sum }
  end
end

# ============================================================================
# morph vs then (should be identical - they're aliases)
# ============================================================================

BenchmarkHelper.run("morph vs then (alias verification)") do |x|
  x.report("morph") { number.morph { |n| n * 2 } }
  x.report("then") { number.then { |n| n * 2 } }
end
