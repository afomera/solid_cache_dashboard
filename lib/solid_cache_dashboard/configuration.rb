module SolidCacheDashboard
  class Configuration
    attr_accessor :title

    def initialize
      @title = "Solid Cache Dashboard"
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
