module LogCleaner
  class Config
    attr_accessor :mask_fields

    def initialize
      @mask_fields = []
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end
end
