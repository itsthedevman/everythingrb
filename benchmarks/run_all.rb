#!/usr/bin/env ruby
# frozen_string_literal: true

# Run all EverythingRB benchmarks
#
# Usage:
#   ruby benchmarks/run_all.rb                    # Run all benchmarks
#   ruby benchmarks/run_all.rb array hash         # Run specific benchmarks
#   LOAD_ACTIVE_SUPPORT=true ruby benchmarks/run_all.rb  # Include ActiveSupport benchmarks
#
# Available benchmarks:
#   array, hash, string, enumerable, ostruct, module, kernel, quotable

BENCHMARK_DIR = File.expand_path(__dir__)

AVAILABLE_BENCHMARKS = %w[
  array
  hash
  string
  enumerable
  ostruct
  module
  kernel
  quotable
].freeze

def run_benchmark(name)
  file = File.join(BENCHMARK_DIR, "#{name}_benchmark.rb")

  if File.exist?(file)
    load file
  else
    puts "Warning: Benchmark file not found: #{file}"
  end
end

def print_header
  puts
  puts "#" * 70
  puts "#" + "EverythingRB Benchmarks".center(68) + "#"
  puts "#" * 70
  puts
  puts "Ruby version: #{RUBY_VERSION}"
  puts "Platform: #{RUBY_PLATFORM}"
  puts "ActiveSupport: #{ENV["LOAD_ACTIVE_SUPPORT"] == "true" ? "loaded" : "not loaded"}"
  puts
  puts "Tip: Run with LOAD_ACTIVE_SUPPORT=true to include ActiveSupport benchmarks"
  puts
end

def print_footer
  puts
  puts "#" * 70
  puts "#" + "Benchmarks Complete".center(68) + "#"
  puts "#" * 70
  puts
end

# Main execution
print_header

benchmarks_to_run = ARGV.empty? ? AVAILABLE_BENCHMARKS : ARGV

benchmarks_to_run.each do |benchmark|
  if AVAILABLE_BENCHMARKS.include?(benchmark)
    run_benchmark(benchmark)
  else
    puts "Unknown benchmark: #{benchmark}"
    puts "Available benchmarks: #{AVAILABLE_BENCHMARKS.join(", ")}"
    exit 1
  end
end

print_footer
