# frozen_string_literal: true

require "spec_helper"

RSpec.describe LogCleaner::RequestMiddleware do
  it "sets and clears request_id per request" do
    app = lambda do |_env|
      expect(LogCleaner::RequestStore.request_id).to match(/^req-/)
      [200, {}, ["OK"]]
    end

    middleware = described_class.new(app)

    middleware.call({})

    expect(LogCleaner::RequestStore.request_id).to be_nil
  end
end
