# frozen_string_literal: true

require_relative "lib/log_cleaner/version"

Gem::Specification.new do |spec|
  spec.name                  = "log_cleaner"
  spec.version               = LogCleaner::VERSION
  spec.authors               = ["Shubham Chauhan"]
  spec.email                 = ["shubham.chauhan@yabx.co"]

  spec.summary               = "Structured logging with automatic sensitive data masking"
  spec.description           = "LogCleaner provides structured JSON logging with automatic masking of
                                sensitive fields like passwords and authentication tokens across requests,
                                controllers, and ActiveRecord."
  spec.homepage              = "https://github.com/shubham-chauhan-dev/log_cleaner"
  spec.license               = "MIT"

  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/shubham-chauhan-dev/log_cleaner",
    "documentation_uri" => "https://rubydoc.info/gems/log_cleaner",
    "changelog_uri" => "https://github.com/shubham-chauhan-dev/log_cleaner/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  # Files included in the gem
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL).read.split("\x0").reject do |f|
    f == gemspec || f.start_with?(
      "bin/",
      "test/",
      "spec/",
      "features/",
      ".git",
      ".github",
      "appveyor",
      "Gemfile"
    )
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
