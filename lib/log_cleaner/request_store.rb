# frozen_string_literal: true

# LogCleaner::RequestStore provides thread-local storage for per-request data,
# specifically the `request_id`. This allows logs to be correlated across
# different parts of the application during a single HTTP request.
#
# Features:
# - Stores a unique request ID in thread-local storage.
# - Ensures each request's ID is isolated and cleared after the request ends.
#
# Example usage:
#
#   # Assign a request ID
#   LogCleaner::RequestStore.request_id = "req-abc123"
#
#   # Retrieve the current request ID
#   LogCleaner::RequestStore.request_id
module LogCleaner
  # Request store
  module RequestStore
    def self.request_id
      Thread.current[:log_cleaner_request_id]
    end

    def self.request_id=(id)
      Thread.current[:log_cleaner_request_id] = id
    end
  end
end
