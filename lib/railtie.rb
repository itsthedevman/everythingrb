# frozen_string_literal: true

module Everythingrb
  #
  # Rails integration for EverythingRB
  #
  # This Railtie handles proper loading of EverythingRB extensions in a Rails environment,
  # ensuring that everything works correctly with ActiveSupport and other Rails components.
  #
  # @example Configure which extensions to load in an initializer
  #   # config/initializers/everythingrb.rb
  #   Rails.application.configure do
  #     config.everythingrb.extensions = [:array, :string, :hash]
  #   end
  #
  # @note By default, all extensions are loaded. Setting `extensions` to an empty array
  #   effectively disables the gem.
  #
  class Railtie < Rails::Railtie
    config.everythingrb = ActiveSupport::OrderedOptions.new
    config.everythingrb.extensions = nil # Default to loading all

    initializer "everythingrb.initialize" do
      # I learned that, whereas ActiveSupport is defined at this point, the core_ext files are
      # required later down the line.
      ActiveSupport.on_load(:active_record) do
        require_relative "everythingrb/prelude"

        extensions = Rails.configuration.everythingrb.extensions

        if extensions.is_a?(Array)
          # Allow selective loading
          extensions.each { |ext| require_relative "everythingrb/#{ext}" }
        else
          require_relative "everythingrb/all"
        end
      end
    end
  end
end
