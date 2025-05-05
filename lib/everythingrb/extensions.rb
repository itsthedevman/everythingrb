# frozen_string_literal: true

Dir[File.expand_path("./extensions/**/*.rb", __dir__)].each { |path| require path }
