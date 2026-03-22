# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

# Load ActiveSupport first if requested
if ENV["LOAD_ACTIVE_SUPPORT"] == "true"
  require "active_support"
  require "active_support/core_ext"
end

require "everythingrb"

# Helper module for benchmark formatting and utilities
module BenchmarkHelper
  class << self
    def header(title)
      puts "\n" + "=" * 70
      puts title.center(70)
      puts "=" * 70
    end

    def section(title)
      puts "\n#{"-" * 30}"
      puts title
      puts "-" * 30
    end

    def run(title, warmup: 2, time: 5, &block)
      section(title)

      Benchmark.ips do |x|
        x.config(warmup:, time:)
        block.call(x)
      end
    end

    def active_support?
      defined?(ActiveSupport)
    end
  end
end
