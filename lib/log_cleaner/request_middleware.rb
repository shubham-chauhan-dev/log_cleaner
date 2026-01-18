# lib/log_cleaner/request_middleware.rb
require "securerandom"

module LogCleaner
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
