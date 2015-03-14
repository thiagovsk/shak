require 'yaml'

module Shak
  class ApplicationSerializer

    def serialize(application, stream)
      data = {
        'name' => application.name,
        'cookbook_name' => application.cookbook_name,
        'path' => application.path,
        # TODO cookbook attributes
      }
      stream.write(YAML.dump(data))
    end

    def read(stream)
      Shak::Application.new.tap do |app|
        data = YAML.load(stream)
        app.name = data['name']
        app.cookbook_name = data['cookbook_name']
        app.path = data['path']
        # FIXME cookbook attributes
      end
    end

  end
end
