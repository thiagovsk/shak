module Shak

  class Config

    attr_accessor :verbose

    def data_dir
      @data_dir ||= ENV['SHAK_DATA_DIR'] || '/var/lib/shak'
    end

    def repository_dir
      File.join(data_dir, 'repository')
    end

    def cookbooks_dir
      @cookbooks_dir ||= File.expand_path('../cookbooks', __FILE__)
    end

  end

  def self.config
    @config ||= Shak::Config.new
  end

end
