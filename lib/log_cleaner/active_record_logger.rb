# frozen_string_literal: true

require "active_support/concern"

# LogCleaner::ActiveRecordLogger is a concern for ActiveRecord models
# that automatically logs validation errors after the model is validated.
#
# Features:
# - Hooks into ActiveRecord's `after_validation` callback.
# - Logs all validation errors with model name, attributes, and user context.
# - Uses LogCleaner.error to standardize log structure.
#
# Example usage in a Rails model:
#
#   class User < ApplicationRecord
#     include LogCleaner::ActiveRecordLogger
#   end
#
# When a User model fails validation, a structured log is sent to LogCleaner:
#   LogCleaner.error(
#     event: "model_validation_failed",
#     model: "User",
#     attributes: { name: "John", email: "invalid" },
#     errors: { email: ["is invalid"] },
#     user_id: 1
#   )
module LogCleaner
  # ActiveRecordLogger
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
