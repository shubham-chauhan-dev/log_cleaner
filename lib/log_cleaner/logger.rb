# frozen_string_literal: true

require "json"
require "securerandom"
require "logger"
require "time" # Needed for iso8601 timestamps
require_relative "request_store"
require_relative "config"

# LogCleaner
module LogCleaner
  # logger
  class Logger
    def initialize
      # Standard Ruby Logger, output to stdout
      @logger = ::Logger.new($stdout)
      # Formatter: print ONLY the message (our JSON), no Ruby Logger prefix
      @logger.formatter = ->(_severity, _datetime, _progname, msg) { "#{msg}\n" }
    end

    # Public methods for log levels
    def info(data)
      log("info", data)
    end

    def debug(data)
      log("debug", data)
    end

    def warn(data)
      log("warn", data)
    end

    def error(data)
      log("error", data)
    end

    private

    # Core logging logic
    def log(level, data)
      payload = build_payload(level, data)
      json_pretty = JSON.pretty_generate(payload)

      formatted_msg = "\n#{"*" * 50}\n#{json_pretty}\n#{"*" * 50}\n"

      @logger.public_send(level, formatted_msg)
    end

    # Build structured JSON payload
    def build_payload(level, data)
      filtered_data = mask_sensitive(data)

      {
        timestamp: Time.now.utc.iso8601,
        level: level,
        request_id: RequestStore.request_id || "req-#{SecureRandom.hex(4)}"
      }.merge(filtered_data)
    end

    # Recursive masking for nested hashes and arrays
    def mask_sensitive(data)
      case data
      when Hash
        mask_sensitive_for_hash(data)
      when Array
        data.map { |v| mask_sensitive(v) }
      else
        data
      end
    end

    def mask_sensitive_for_hash(data)
      data.each_with_object({}) do |(key, value), result|
        key_sym = safe_to_sym(key)
        result[key_sym] = mask_sensitive_fileds?(key_sym, value)
      end
    end

    def mask_sensitive_fileds?(key_sym, value)
      LogCleaner.config.mask_fields.include?(key_sym) ? "[FILTERED]" : mask_sensitive(value)
    end

    # Safely convert a key to symbol
    def safe_to_sym(key)
      key.to_sym
    rescue StandardError
      key
    end
    private :safe_to_sym
  end

  # Singleton logger instance
  def self.logger
    @logger ||= Logger.new
  end

  # Convenience methods
  def self.info(data)
    logger.info(data)
  end

  def self.debug(data)
    logger.debug(data)
  end

  def self.warn(data)
    logger.warn(data)
  end

  def self.error(data)
    logger.error(data)
  end
end
