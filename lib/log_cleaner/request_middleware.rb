# frozen_string_literal: true

require "securerandom"

# LogCleaner::RequestMiddleware is a Rack middleware that assigns a unique
# request ID to each incoming HTTP request. This ID is stored in
# RequestStore and is used for correlating logs throughout the request lifecycle.
#
# It ensures:
# - A unique `request_id` is available for every request.
# - The request ID is cleared after the request completes to prevent leakage.
#
# Example usage in Rails:
#
#   Rails.application.config.middleware.use LogCleaner::RequestMiddleware
module LogCleaner
  # Middleware
  class RequestMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # Assign a unique request ID per HTTP request
      RequestStore.request_id = "req-#{SecureRandom.hex(4)}"
      @app.call(env)
    ensure
      # Clear the thread after request ends to prevent leakage
      RequestStore.request_id = nil
    end
  end
end
