# LogCleaner

Structured JSON logging for Ruby applications with automatic masking of sensitive fields like passwords, tokens, and authentication headers.

---

## Features

- Structured JSON logs for requests, controllers, and ActiveRecord
- Automatic masking of sensitive fields (`password`, `token`, `authorization`)
- Request middleware support for unique request IDs
- Configurable mask fields
- Rails-friendly, works in controllers and models

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem "log_cleaner"

Then run:

bundle install

Or install the gem manually:

gem install log_cleaner

Usage

Configure masked fields

LogCleaner.configure do |config|
  config.mask_fields = [:password, :token]
end


Log structured data

LogCleaner.info(
  event: "user_login",
  email: "user@example.com",
  password: "secret123",
  token: "abcd1234"
)

Output:
{
  "timestamp": "2026-01-18T07:00:00Z",
  "level": "info",
  "request_id": "req-1234abcd",
  "event": "user_login",
  "email": "user@example.com",
  "password": "[FILTERED]",
  "token": "[FILTERED]"
}
