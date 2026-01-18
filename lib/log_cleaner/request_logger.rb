# frozen_string_literal: true

require "active_support/concern"

# LogCleaner::RequestLogger is a Rails controller concern that automatically
# logs request and response information for every controller action.
#
# Features:
# - Wraps controller actions using `around_action` to capture execution time.
# - Logs structured JSON containing:
#     - Event type ("controller_request")
#     - Controller and action names
#     - HTTP status code
#     - Request duration in milliseconds
#     - Request parameters (with sensitive fields masked)
#     - Request body (with sensitive fields masked)
#     - URL, HTTP method, client IP
#     - User ID (if `current_user` is defined)
# - Allows manual addition of extra log fields using `log_cleaner_info`.
# - Integrates with LogCleaner.logger for centralized logging.
#
# Usage:
#
#   class ApplicationController < ActionController::Base
#     include LogCleaner::RequestLogger
#   end
#
# Masking sensitive fields can be configured globally:
#
#   LogCleaner.configure do |config|
#     config.mask_fields = [:password, :credit_card_number]
#   end
#
# Example log output:
#
#   {
#     "timestamp": "...",
#     "level": "info",
#     "request_id": "req-abc123",
#     "event": "controller_request",
#     "controller": "users",
#     "action": "create",
#     "status": 201,
#     "duration_ms": 42.15,
#     "params": { "email": "user@example.com", "password": "[FILTERED]" },
#     "request_body": { "password": "[FILTERED]" },
#     "url": "http://localhost:3000/users",
#     "method": "POST",
#     "ip": "127.0.0.1",
#     "user_id": 1
#   }
module LogCleaner
  # RequestLogger
  module RequestLogger
    extend ActiveSupport::Concern

    included do
      around_action :log_request
    end

    private

    # Main logging wrapper
    def log_request
      start_time = Time.now
      yield
    ensure
      duration = ((Time.now - start_time) * 1000).round(2) # ms

      # Merge default log info with any manual info set in @log_cleaner_manual_info
      log_data = prepare_hash_data(duration)

      # Merge any manual info passed via LogCleaner.info call in controller
      log_data.merge!(@log_cleaner_manual_info) if defined?(@log_cleaner_manual_info)

      # Perform logging
      LogCleaner.info(log_data)
    end

    def prepare_hash_data(duration)
      { event: "controller_request", controller: controller_name, action: action_name,
        status: safe_status, duration_ms: duration, params: safe_filtered_params,
        request_body: safe_request_body, url: request.url, method: request.request_method,
        ip: request.remote_ip, user_id: safe_user_id }
    end

    # Safe response status
    def safe_status
      response&.status || 0
    end

    # Recursively mask params
    def safe_filtered_params
      return {} unless params.respond_to?(:to_unsafe_h)

      deep_mask(params.to_unsafe_h, LogCleaner.config.mask_fields)
    end

    # Recursively mask request_body
    def safe_request_body
      body = request.body.read
      request.body.rewind
      parsed = JSON.parse(body)
      deep_mask(parsed, LogCleaner.config.mask_fields)
    rescue JSON::ParserError, TypeError
      {}
    end

    # Recursive masking helper
    def deep_mask(obj, mask_fields)
      case obj
      when Array
        obj.map { |v| deep_mask(v, mask_fields) }

      when Hash, ActionController::Parameters
        deep_mask_for_hash?(obj, mask_fields)
      else
        obj
      end
    end

    def deep_mask_for_hash?(obj, mask_fields)
      obj.to_h.each_with_object({}) do |(k, v), result|
        key = begin
          k.to_sym
        rescue StandardError
          k
        end

        result[key] = mask_fields.include?(key) ? "[FILTERED]" : deep_mask(v, mask_fields)
      end
    end

    # Safe current_user logging
    def safe_user_id
      u = defined?(current_user) ? current_user : nil
      if u.is_a?(Array)
        u.first&.id
      else
        u&.id
      end
    end

    # **Helper to allow direct LogCleaner.info calls with custom info**
    def log_cleaner_info(info = {})
      @log_cleaner_manual_info = info
      LogCleaner.info(info)
    end
  end
end
