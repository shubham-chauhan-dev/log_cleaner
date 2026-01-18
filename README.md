# LogCleaner

LogCleaner is a Ruby gem for **structured JSON logging** with automatic **masking of sensitive fields** such as passwords, emails, and authentication tokens. It works with Rails controllers, middleware, and ActiveRecord models.

---

## Features

- Structured JSON logs for Rails controllers and ActiveRecord
- Automatic masking of sensitive fields (`password`, `email`, `authenticity_token`, etc.)
- Middleware support for request IDs
- Configurable mask fields per environment
- Supports custom log messages

---

## Installation

### 1. Add the Gem

Add `log_cleaner` to your Gemfile:

```ruby
# Gemfile
gem 'log_cleaner'
```

Then install the gem:
```
bundle install
```
## Create an Initializer

```Create a file for configuring masked fields:
touch config/initializers/log_cleaner.rb
```
Add the following content:
```
# config/initializers/log_cleaner.rb
LogCleaner.configure do |c|
  if Rails.env.production?
    # Mask sensitive fields in production
    c.mask_fields = [:email, :password, :authenticity_token]
  else
    # Only mask password and authenticity_token in development
    c.mask_fields = [:password, :authenticity_token]
  end
end
```

✅ This ensures sensitive data is masked automatically in logs.

## Include in ApplicationController

```Include LogCleaner::RequestLogger to clean logs for every request:
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include LogCleaner::RequestLogger
end
```

## Restart Rails Server

```After making changes, restart your Rails server:
rails server
```

## Verify Logs

Check your server logs (log/development.log or log/production.log) to see masked fields.

Example output:

```
**************************************************
{
  "timestamp": "2026-01-17T18:03:37Z",
  "level": "info",
  "request_id": "req-97efe591",
  "event": "controller_request",
  "controller": "omniauth",
  "action": "username_password_authenticate",
  "status": 302,
  "duration_ms": 492.15,
  "params": {
    "authenticity_token": "[FILTERED]",
    "session": "[FILTERED]",
    "commit": "Login",
    "controller": "omniauth",
    "action": "username_password_authenticate"
  },
  "request_body": {},
  "url": "http://lms-in.yabx.local:3000/authenticate",
  "method": "POST",
  "ip": "127.0.0.1",
  "user_id": 1
}
**************************************************
```

## Adding Custom Logs if you want then

You can log custom messages while keeping sensitive fields masked, Add this line for any action or any place:

```
LogCleaner.log("Custom Info: User signup started", current_user: current_user.id)
```
Example log output:

```
[INFO] Custom Info: User signup started {"current_user": 1}
```

Note: You can change the key or value according your own requirments.


## Contributing

Bug reports and pull requests are welcome on GitHub: [LogCleaner](https://github.com/shubham-chauhan-dev/log_cleaner)

1. Fork the repository
2. Create a branch (git checkout -b feature-name)
3. Make your changes
4. Submit a pull request


## License


---

This README is **fully complete**:

- ✅ Installation steps  
- ✅ Initializer setup with masked fields  
- ✅ Controller integration  
- ✅ ActiveRecord logging example  
- ✅ Middleware usage  
- ✅ Custom logs  
- ✅ Proper Markdown formatting  
- ✅ GitHub link in Contributing section  

---

If you want, I can also **prepare a `docs/` folder with screenshots and example logs** that match this README so you can attach them for visual documentation.  

Do you want me to do that next?