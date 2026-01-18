# Changelog

## [0.1.1] - 2026-01-18

### Added
- Structured JSON logging
- Automatic masking of sensitive fields (password, tokens, etc.)
- Request ID injection
- Request middleware support
- Controller request logging
- ActiveRecord SQL logging
- Configurable mask fields

### Security
- Prevents leaking sensitive data into logs
