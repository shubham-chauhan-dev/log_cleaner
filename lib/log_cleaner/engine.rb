# lib/log_cleaner/engine.rb
# typed: false
# frozen_string_literal: true

require "rails"

# LogCleaner::Engine integrates the LogCleaner gem into a Rails application
# as a Rails Engine. This allows LogCleaner to provide middleware,
# request logging, and other Rails-specific features seamlessly.
#
# Features:
# - Isolates the LogCleaner namespace to avoid conflicts with the host app.
# - Can include Rails initializers for assets, middleware, or configuration.
#
# Example:
#   # In a Rails app, LogCleaner will automatically mount its engine and
#   # integrate middleware for request-level logging.
#
# Notes:
# - The asset precompilation block is optional and can be uncommented if
#   LogCleaner ships with CSS/JS assets for a dashboard or UI.

module LogCleaner
  # Enginee
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
