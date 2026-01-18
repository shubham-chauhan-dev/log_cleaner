# frozen_string_literal: true

# LogCleaner::Config handles the configuration settings for the LogCleaner module.
#
# Features:
# - Stores configurable options for LogCleaner, such as fields that should be masked in logs.
# - Provides a central place to manage logging behavior across the application.
#
# Configuration example:
#
#   LogCleaner.configure do |config|
#     config.mask_fields = [:password, :credit_card_number]
#   end
#
# This ensures that sensitive fields are masked in all logs handled by LogCleaner.
module LogCleaner
  # Config
  class Config
    attr_accessor :mask_fields

    def initialize
      @mask_fields = []
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end
end
