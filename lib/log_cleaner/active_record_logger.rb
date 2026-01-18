# lib/log_cleaner/active_record_logger.rb
module LogCleaner
  module ActiveRecordLogger
    extend ActiveSupport::Concern

    included do
      # Hook after validation
      after_validation :log_validation_errors, if: -> { errors.any? }
    end

    private

    def log_validation_errors
      LogCleaner.error(
        event: "model_validation_failed",
        model: self.class.name,
        attributes: attributes.slice(*self.class.attribute_names),
        errors: errors.to_hash,
        user_id: defined?(current_user) ? current_user&.id : nil
      )
    end
  end
end
