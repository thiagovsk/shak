require 'yaml'

module Shak
  module Context
    class SerializeApplication

      def initialize(application)
        @application = application
      end

      def serialize(stream)
        data = {
          'name' => @application.name,
          'cookbook_name' => @application.cookbook_name,
          # TODO cookbook attributes
        }
        stream.write(YAML.dump(data))
      end

    end
  end
end
