# frozen_string_literal: true

require "ostruct"
require "json"

#
# EverythingRB - Super handy extensions to Ruby's core classes
#
# This gem enhances Ruby's built-in classes with useful methods that make
# your code more expressive and fun to write. Just require "everythingrb"
# and all the extensions are automatically available!
#
# @author Bryan "itsthedevman"
# @since 0.1.0
#
# @example Basic usage
#   # In your Gemfile
#   gem "everythingrb"
#
#   # In your code
#   require "everythingrb"
#
#   # Now you have access to all the extensions!
#   users = [{name: "Alice"}, {name: "Bob"}]
#   users.key_map(:name).join(", ")  # => "Alice, Bob"
#
module Everythingrb
  def self.deprecator
    @deprecator ||= if defined?(ActiveSupport)
      ActiveSupport::Deprecation.new(VERSION, "everythingrb")
    else
      proxy = Data.define
      proxy.define_method(:warn) { |message| puts "DEPRECATION WARNING: #{message}" }
      proxy.new
    end
  end
end

require_relative "extensions"
require_relative "version"
