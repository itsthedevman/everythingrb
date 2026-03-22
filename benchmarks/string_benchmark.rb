# frozen_string_literal: true

require_relative "benchmark_helper"

BenchmarkHelper.header("String Extension Benchmarks")

# Test data
simple_json = '{"name": "Alice", "age": 30}'
nested_json = '{"user": {"profile": {"name": "Alice"}, "settings": {"theme": "dark"}}}'
large_json = "{" + (1..100).map { |i| %("key#{i}": #{i}) }.join(", ") + "}"
invalid_json = "not valid json"

simple_string = "hello_world"
complex_string = "welcome to the jungle!"
mixed_string = "please-WAIT while_loading..."
special_chars = "test@#$%^&*()string_with-special.chars!"

# ============================================================================
# parse_json benchmarks
# ============================================================================

BenchmarkHelper.run("parse_json - simple JSON") do |x|
  x.report("parse_json") { simple_json.parse_json }
  x.report("parse_json(symbolize: false)") { simple_json.parse_json(symbolize_names: false) }
end

BenchmarkHelper.run("parse_json - nested JSON") do |x|
  x.report("parse_json") { nested_json.parse_json }
end

BenchmarkHelper.run("parse_json - large JSON (100 keys)") do |x|
  x.report("parse_json") { large_json.parse_json }
end

BenchmarkHelper.run("parse_json - invalid JSON") do |x|
  x.report("parse_json (returns nil)") { invalid_json.parse_json }
end

# ============================================================================
# to_istruct / to_ostruct / to_struct benchmarks
# ============================================================================

BenchmarkHelper.run("JSON to struct conversions - simple") do |x|
  x.report("to_istruct") { simple_json.to_istruct }
  x.report("to_ostruct") { simple_json.to_ostruct }
  x.report("to_struct") { simple_json.to_struct }
end

BenchmarkHelper.run("JSON to struct conversions - nested") do |x|
  x.report("to_istruct") { nested_json.to_istruct }
  x.report("to_ostruct") { nested_json.to_ostruct }
  x.report("to_struct") { nested_json.to_struct }
end

# ============================================================================
# to_camelcase benchmarks
# ============================================================================

BenchmarkHelper.run("to_camelcase - simple underscore string") do |x|
  x.report("to_camelcase(:upper)") { simple_string.to_camelcase }
  x.report("to_camelcase(:lower)") { simple_string.to_camelcase(:lower) }
end

BenchmarkHelper.run("to_camelcase - complex string with spaces") do |x|
  x.report("to_camelcase(:upper)") { complex_string.to_camelcase }
  x.report("to_camelcase(:lower)") { complex_string.to_camelcase(:lower) }
end

BenchmarkHelper.run("to_camelcase - mixed formatting") do |x|
  x.report("to_camelcase(:upper)") { mixed_string.to_camelcase }
end

BenchmarkHelper.run("to_camelcase - special characters") do |x|
  x.report("to_camelcase(:upper)") { special_chars.to_camelcase }
end

# ============================================================================
# in_quotes / with_quotes benchmarks
# ============================================================================

BenchmarkHelper.run("in_quotes / with_quotes") do |x|
  x.report("short string in_quotes") { "hello".in_quotes }
  x.report("medium string in_quotes") { complex_string.in_quotes }
  x.report("with_quotes (alias)") { complex_string.with_quotes }
end
