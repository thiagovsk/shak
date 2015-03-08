module Shak

  class Config

    def data_dir
      @data_dir ||= ENV['SHAK_DATA_DIR'] || '/var/lib/shak'
    end

    def cookbooks_dir
      @cookbooks_dir ||= File.expand_path('../cookbooks', __FILE__)
    end

  end

  def self.config
    @config ||= Shak::Config.new
  end

end
