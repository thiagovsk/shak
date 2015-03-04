module Shak

  class Config

    def data_dir
      @data_dir ||= ENV['SHAK_DATA_DIR'] || '/var/lib/shak'
    end

  end

  def self.config
    @config ||= Shak::Config.new
  end

end
