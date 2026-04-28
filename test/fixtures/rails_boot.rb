# frozen_string_literal: true

# Boots a minimal Rails::Application using only the documented install
# (`gem "everythingrb"`, no initializer, no manual require). The model in
# fixtures/models exercises an extension from each major category at
# class-body time AND runtime, so a missing extension fails either
# eager_load (prod) or autoload (dev).
#
# Spawned as a subprocess by test/test_rails_boot.rb. Reads EAGER_LOAD
# from the environment to switch between the dev (false) and prod (true)
# Rails configurations.

require "logger"
require "rails"
require "everythingrb"

class WidgetApp < Rails::Application
  config.eager_load = ENV.fetch("EAGER_LOAD") == "true"
  config.cache_classes = config.eager_load
  config.root = __dir__

  models_path = File.expand_path("models", __dir__)
  config.autoload_paths << models_path
  config.eager_load_paths << models_path

  config.logger = Logger.new(IO::NULL)
  config.secret_key_base = "test_secret_key_base"
end

WidgetApp.initialize!

# Force-reference the model so dev (lazy autoload) hits the same surface
# that prod hit during eager_load. Also exercises a runtime call into
# extensions on Array and Hash.
widget = Widget.new(active: true)
raise "Module#attr_predicate broken: active? returned #{widget.active?.inspect}" unless widget.active?
raise "Array#key_map broken: NAMES = #{Widget::NAMES.inspect}" unless Widget::NAMES == %w[Alice Bob]
raise "Hash#transform_values(with_key:) broken: #{widget.tagged.inspect}" \
  unless widget.tagged == {a: "a=1", b: "b=2"}

puts "ok"
