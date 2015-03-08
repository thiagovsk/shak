require 'yaml'

module Shak
  module Context
    class SerializeSite

      def initialize(site)
        @site = site
      end

      def serialize(stream)
        data = {
          'hostname' => @site.hostname,
          'name' => @site.name,
          'ssl' => @site.ssl,
          'www' => @site.www,
        }
        stream.write(YAML.dump(data))
      end

    end
  end
end
