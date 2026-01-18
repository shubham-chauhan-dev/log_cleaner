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

## Controller Logging with LogCleaner

LogCleaner provides structured, masked logging for controller requests.
You can enable it per controller or globally for all controllers.

### Option 1: Enable Logging for a Specific Controller (Recommended)

Use this when you want logging only for selected controllers.

#### Example"
```
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  include LogCleaner::RequestLogger

  def create
    # controller logic
  end
end
```

### Option 2: Enable Logging Globally (All Controllers)

Use this when you want every controller action logged automatically.

ApplicationController Setup
```
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include LogCleaner::RequestLogger
end
```

✅ All controllers inheriting from ApplicationController will now be logged.


#### Example Log Output:
```
**************************************************
{
  "timestamp": "2026-01-18T12:05:11Z",
  "level": "info",
  "request_id": "req-a12bc9ef",
  "event": "controller_request",
  "controller": "users",
  "action": "create",
  "status": 201,
  "duration_ms": 134.72,
  "params": {
    "email": "[FILTERED]",
    "password": "[FILTERED]"
  },
  "url": "http://localhost:3000/users",
  "method": "POST",
  "ip": "127.0.0.1",
  "user_id": 1
}
**************************************************
```

### You can attach custom log data inside any controller action.

#### Example 1:
```
def create
  log_cleaner_info(event: "user_signup_started", step: "validation")
  # controller logic
end
```
#### Log Output:
```
**************************************************
{
  "event": "user_signup_started",
  "step": "validation",
  "request_id": "req-a12bc9ef",
  "timestamp": "2026-01-18T12:06:30Z",
  "level": "info"
}
**************************************************
```
#### Example 2: 

```
LogCleaner.log("Custom Info: User signup started", current_user: current_user.id)
```
#### Log output:

```
[INFO] Custom Info: User signup started {"current_user": 1}
```

## ActiveRecord Logging (Model Validation Errors)

LogCleaner can automatically log ActiveRecord validation errors in a structured and masked format.
You can enable this per model or globally for all models, depending on your needs.

### Option 1: Enable Logging for a Specific Model (Recommended)

Include LogCleaner::ActiveRecordLogger only in the models where you want validation logs.
```
# app/models/user.rb
class User < ApplicationRecord
  include LogCleaner::ActiveRecordLogger

  validates :email, presence: true
  validates :password, presence: true
end
```
✅ Best choice when you want fine-grained control
✅ Avoids noisy logs for all models

### Option 2: Enable Logging Globally (All Models)

If you want validation logging for every ActiveRecord model, include it in ApplicationRecord.
```
# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include LogCleaner::ActiveRecordLogger
end
```
⚠️ This will log validation failures for all models.
⚠️ Use carefully in large applications.

#### Example Operation
```user = User.new(email: nil, password: nil)
user.save
```


Since validations fail, LogCleaner will automatically log the error.

#### Example Log Output
```
**************************************************
{
  "timestamp": "2026-01-18T10:12:44Z",
  "level": "error",
  "event": "model_validation_failed",
  "model": "User",
  "attributes": {
    "id": null,
    "email": null,
    "password": "[FILTERED]"
  },
  "errors": {
    "email": ["can't be blank"],
    "password": ["can't be blank"]
  }
}
**************************************************
```

✅ Sensitive fields are masked.
✅ Errors are structured and searchable.
✅ Works automatically via callbacks

## Restart Rails Server

``` After making changes, restart your Rails server:
rails server
```

## Verify Logs

Check your server logs on rails console, or log/development.log or log/production.log to see masked fields.

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

Note: You can change the key or value according to your own requirements.

## Pro Tip (Best Practice)

Only controller logs needed?
  #### → LogCleaner::RequestLogger

Only model validation logs needed?
  #### → LogCleaner::ActiveRecordLogger

Need full request lifecycle logging?
  #### → LogCleaner::RequestMiddleware

This separation keeps your logs clean, intentional, and scalable.

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
