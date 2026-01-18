# frozen_string_literal: true

# lib/log_cleaner.rb

# = LogCleaner
#
# LogCleaner provides structured JSON logging for Rails applications with
# automatic masking of sensitive fields such as passwords, emails, and tokens.
#
# == Installation
#
#   gem "log_cleaner"
#
#   bundle install
#
# == Configuration
#
#   LogCleaner.configure do |c|
#     c.mask_fields = [:password, :authenticity_token]
#   end
#
# == Controller Logging
#
#   class ApplicationController < ActionController::Base
#     include LogCleaner::RequestLogger
#   end
#
# == ActiveRecord Logging
#
#   class User < ApplicationRecord
#     include LogCleaner::ActiveRecordLogger
#   end
#
# == Middleware
#
#   config.middleware.use LogCleaner::RequestMiddleware
#
# == Documentation
#
# * RubyDoc: https://rubydoc.info/gems/log_cleaner
# * GitHub:  https://github.com/shubham-chauhan-dev/log_cleaner
# * RubyGems: https://rubygems.org/gems/log_cleaner
#
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
