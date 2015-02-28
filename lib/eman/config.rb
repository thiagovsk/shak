module Eman

  class Config

    def data_dir
      @data_dir ||= ENV['EMAN_DATA_DIR'] || '/var/lib/eman'
    end

    def cookbooks_dir
      @data_dir ||= ENV['EMAN_COOKBOOKS_DIR'] || '/usr/share/eman/cookbooks'
    end

  end

  def self.config
    @config ||= Eman::Config.new
  end

end
