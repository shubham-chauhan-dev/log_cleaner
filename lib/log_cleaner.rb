# log_cleaner/lib/log_cleaner.rb
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
