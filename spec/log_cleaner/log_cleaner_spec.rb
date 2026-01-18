# frozen_string_literal: true

require "spec_helper"
require "stringio"

RSpec.describe LogCleaner::Logger do
  before do
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stdout = @original_stdout
  end

  it "logs structured JSON and masks sensitive fields" do
    LogCleaner.configure do |config|
      config.mask_fields = [:password]
    end

    LogCleaner.info(
      event: "user_login",
      email: "test@example.com",
      password: "secret123"
    )

    output = $stdout.string

    expect(output).to include('"event": "user_login"')
    expect(output).to include('"level": "info"')
    expect(output).to include('"email": "test@example.com"')
    expect(output).to include('"password": "[FILTERED]"')
    expect(output).to include('"timestamp"')
    expect(output).to include('"request_id"')
  end
end
