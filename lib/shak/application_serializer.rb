require 'yaml'

require 'shak/application'

module Shak
  class ApplicationSerializer

    def serialize(application, stream)
      data = {
        'name' => application.name,
        'id' => application.id,
      }.merge(application.input_data)
      stream.write(YAML.dump(data))
    end

    def read(stream)
      data = YAML.load(stream)
      name = data.delete('name')
      id = data.delete('id')

      Shak::Application.new(name, id).tap do |app|
        app.input_data = data
      end
    end

  end
end
