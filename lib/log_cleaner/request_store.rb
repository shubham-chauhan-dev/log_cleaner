module LogCleaner
  module RequestStore
    def self.request_id
      Thread.current[:log_cleaner_request_id]
    end

    def self.request_id=(id)
      Thread.current[:log_cleaner_request_id] = id
    end
  end
end
