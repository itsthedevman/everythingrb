# frozen_string_literal: true

require "ostruct"
require "json"

require_relative "everythingrb/version"
require_relative "everythingrb/core/array"
require_relative "everythingrb/core/enumerable"
require_relative "everythingrb/core/hash"
require_relative "everythingrb/core/module"
require_relative "everythingrb/core/ostruct"
require_relative "everythingrb/core/string"
require_relative "everythingrb/core/symbol"

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
end
