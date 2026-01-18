# lib/log_cleaner/engine.rb
# typed: false
# frozen_string_literal: true

require "rails"


module LogCleaner
  class Engine < ::Rails::Engine
    isolate_namespace LogCleaner

    # No need to precompile assets if you are using inline CSS/JS
    # initializer "log_cleaner.assets.precompile" do |app|
    #   app.config.assets.precompile += %w[
    #     log_cleaner/dashboard.css
    #     log_cleaner/dashboard.js
    #   ]
    # end
  end
end
