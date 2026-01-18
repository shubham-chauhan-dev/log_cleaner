require "json"
require "securerandom"
require "logger"
require "time"  # Needed for iso8601 timestamps
require_relative "request_store"
require_relative "config"

module LogCleaner
  class Logger
    def initialize
      # Standard Ruby Logger, output to stdout
      @logger = ::Logger.new($stdout)
      # Formatter: print ONLY the message (our JSON), no Ruby Logger prefix
      @logger.formatter = ->(_severity, _datetime, _progname, msg) { "#{msg}\n" }
    end

    # Public methods for log levels
    def info(data); log("info", data); end
    def debug(data); log("debug", data); end
    def warn(data); log("warn", data); end
    def error(data); log("error", data); end

    private

    # Core logging logic
    def log(level, data)
      payload = build_payload(level, data)
      json_pretty = JSON.pretty_generate(payload)

      formatted_msg = "\n#{'*' * 50}\n#{json_pretty}\n#{'*' * 50}\n"

      @logger.public_send(level, formatted_msg)
    end

    # Build structured JSON payload
    def build_payload(level, data)
      filtered_data = mask_sensitive(data)

      {
        timestamp: Time.now.utc.iso8601,
        level: level,
        request_id: RequestStore.request_id || generate_request_id
      }.merge(filtered_data)
    end

    # Recursive masking for nested hashes and arrays
    def mask_sensitive(data)
      case data
      when Hash
        data.transform_keys(&:to_sym).transform_values do |v|
          mask_sensitive_value(v, data.keys)
        end
      when Array
        data.map { |v| mask_sensitive(v) }
      else
        data
      end
    end

    private

    # Mask a value if its key is sensitive; recurse otherwise
    def mask_sensitive_value(value, keys = [])
      key_sym = keys.first.to_sym rescue nil

      if key_sym && LogCleaner.config.mask_fields.include?(key_sym)
        "[FILTERED]"
      else
        mask_sensitive(value) # recursive call for nested hash/array
      end
    end

    # Generate a request ID if one doesn't exist
    def generate_request_id
      "req-#{SecureRandom.hex(4)}"
    end
  end

  # Singleton logger instance
  def self.logger
    @logger ||= Logger.new
  end

  # Convenience methods
  def self.info(data); logger.info(data); end
  def self.debug(data); logger.debug(data); end
  def self.warn(data); logger.warn(data); end
  def self.error(data); logger.error(data); end
end
