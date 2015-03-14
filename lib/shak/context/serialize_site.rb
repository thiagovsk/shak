require 'yaml'

module Shak
  module Context
    class SerializeSite

      def serialize(site, stream)
        data = {
          'hostname' => site.hostname,
          'name' => site.name,
          'ssl' => site.ssl,
          'www' => site.www,
        }
        stream.write(YAML.dump(data))
      end

      def read(stream)
        Shak::Site.new.tap do |site|
          data = YAML.load(stream)
          %w[hostname name ssl www].each do |attr|
            site.send("#{attr}=", data[attr])
          end
        end
      end

    end
  end
end
