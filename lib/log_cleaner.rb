# frozen_string_literal: true

require "json"
require "securerandom"
require "logger"
require "time"

require_relative "log_cleaner/version"
require_relative "log_cleaner/config"
require_relative "log_cleaner/request_store"
require_relative "log_cleaner/logger"
require_relative "log_cleaner/request_middleware"
require_relative "log_cleaner/request_logger"
require_relative "log_cleaner/active_record_logger"
require_relative "log_cleaner/engine"

# LogCleaner is a Ruby library that provides structured logging
# and request-level log management for applications.
#
# It allows you to:
# - Automatically capture and clean logs for HTTP requests.
# - Track logs per request using RequestStore.
# - Integrate with ActiveRecord for database query logging.
# - Configure logging behavior using a central configuration object.
#
# Example usage:
#
#   LogCleaner.configure do |config|
#     config.log_level = :info
#     config.clean_sensitive_data = true
#   end
#
# The library also provides middleware for Rack/Rails applications
# to capture request-specific logs and a custom logger for structured output.
module LogCleaner
  class << self
    attr_accessor :config
  end

  # Configuration
  def self.configure
    self.config ||= Config.new
    yield(config)
  end
end
