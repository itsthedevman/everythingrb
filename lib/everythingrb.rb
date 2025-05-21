# frozen_string_literal: true

require_relative "everythingrb/prelude"

if defined?(Rails::Railtie)
  require_relative "railtie"
else
  require_relative "everythingrb/all"
end
