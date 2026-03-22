# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("Quotable Extension Benchmarks")

# Test data for InspectQuotable types
array_value = [1, 2, 3]
hash_value = {a: 1, b: 2}
true_value = true
false_value = false
nil_value = nil
numeric_int = 42
numeric_float = 3.14159
range_value = 1..10
regexp_value = /hello/
struct_value = Struct.new(:name, :age).new("Alice", 30)

# Test data for StringQuotable types
string_value = "hello world"
date_value = Date.new(2024, 1, 15)
datetime_value = DateTime.new(2024, 1, 15, 12, 30, 0)
time_value = Time.new(2024, 1, 15, 12, 30, 0)

# Symbol has its own implementation
symbol_value = :my_symbol

# ============================================================================
# InspectQuotable types
# ============================================================================

BenchmarkHelper.run("in_quotes - Array") do |x|
  x.report("array.in_quotes") { array_value.in_quotes }
  x.report("array.with_quotes") { array_value.with_quotes }
end

BenchmarkHelper.run("in_quotes - Hash") do |x|
  x.report("hash.in_quotes") { hash_value.in_quotes }
end

BenchmarkHelper.run("in_quotes - Boolean") do |x|
  x.report("true.in_quotes") { true_value.in_quotes }
  x.report("false.in_quotes") { false_value.in_quotes }
end

BenchmarkHelper.run("in_quotes - NilClass") do |x|
  x.report("nil.in_quotes") { nil_value.in_quotes }
end

BenchmarkHelper.run("in_quotes - Numeric") do |x|
  x.report("integer.in_quotes") { numeric_int.in_quotes }
  x.report("float.in_quotes") { numeric_float.in_quotes }
end

BenchmarkHelper.run("in_quotes - Range") do |x|
  x.report("range.in_quotes") { range_value.in_quotes }
end

BenchmarkHelper.run("in_quotes - Regexp") do |x|
  x.report("regexp.in_quotes") { regexp_value.in_quotes }
end

BenchmarkHelper.run("in_quotes - Struct") do |x|
  x.report("struct.in_quotes") { struct_value.in_quotes }
end

# ============================================================================
# StringQuotable types
# ============================================================================

BenchmarkHelper.run("in_quotes - String") do |x|
  x.report("string.in_quotes") { string_value.in_quotes }
  x.report("string.with_quotes") { string_value.with_quotes }
end

BenchmarkHelper.run("in_quotes - Date") do |x|
  x.report("date.in_quotes") { date_value.in_quotes }
end

BenchmarkHelper.run("in_quotes - DateTime") do |x|
  x.report("datetime.in_quotes") { datetime_value.in_quotes }
end

BenchmarkHelper.run("in_quotes - Time") do |x|
  x.report("time.in_quotes") { time_value.in_quotes }
end

# ============================================================================
# Symbol (custom implementation)
# ============================================================================

BenchmarkHelper.run("in_quotes - Symbol") do |x|
  x.report("symbol.in_quotes") { symbol_value.in_quotes }
  x.report("symbol.with_quotes") { symbol_value.with_quotes }
end

# ============================================================================
# All types comparison
# ============================================================================

BenchmarkHelper.run("in_quotes - all types comparison") do |x|
  x.report("Array") { array_value.in_quotes }
  x.report("Hash") { hash_value.in_quotes }
  x.report("String") { string_value.in_quotes }
  x.report("Symbol") { symbol_value.in_quotes }
  x.report("Integer") { numeric_int.in_quotes }
  x.report("nil") { nil_value.in_quotes }
  x.report("true") { true_value.in_quotes }
  x.report("Date") { date_value.in_quotes }
  x.report("Time") { time_value.in_quotes }
end
