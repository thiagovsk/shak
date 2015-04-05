require 'yaml'

require 'shak/application'

module Shak
  class ApplicationSerializer

    def serialize(application, stream)
      data = {
        'name' => application.name,
        'cookbook_name' => application.cookbook_name,
        'path' => application.path,
      }.merge(application.input_data)
      stream.write(YAML.dump(data))
    end

    def read(stream)
      Shak::Application.new.tap do |app|
        data = YAML.load(stream)
        app.name = data.delete('name')
        app.cookbook_name = data.delete('cookbook_name')
        app.path = data.delete('path')
        app.input_data = data
      end
    end

  end
end
