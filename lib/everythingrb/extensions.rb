Dir[File.expand_path("extensions/**/*.rb", __dir__)].each { |path| require path }
