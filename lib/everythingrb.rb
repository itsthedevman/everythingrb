# frozen_string_literal: true

if defined?(Rails::Railtie)
  require_relative "railtie"
else
  require_relative "everythingrb/prelude"
  require_relative "everythingrb/all"
end
