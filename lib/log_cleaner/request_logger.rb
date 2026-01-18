module LogCleaner
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
      log_data = {
        event: "controller_request",
        controller: controller_name,
        action: action_name,
        status: safe_status,
        duration_ms: duration,
        params: safe_filtered_params,
        request_body: safe_request_body,
        url: request.url,
        method: request.request_method,
        ip: request.remote_ip,
        user_id: safe_user_id
      }

      # Merge any manual info passed via LogCleaner.info call in controller
      log_data.merge!(@log_cleaner_manual_info) if defined?(@log_cleaner_manual_info)

      # Perform logging
      LogCleaner.info(log_data)
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
        obj.to_h.each_with_object({}) do |(k, v), result|
          key = k.to_sym rescue k

          if mask_fields.include?(key)
            result[key] = "[FILTERED]"
          else
            result[key] = deep_mask(v, mask_fields)
          end
        end

      else
        obj
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
