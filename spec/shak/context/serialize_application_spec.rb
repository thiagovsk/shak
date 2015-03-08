require "spec_helper"

require 'stringio'
require 'yaml'

require 'shak/application'
require 'shak/context/serialize_application'

describe Shak::Context::SerializeApplication do

  it 'writes in YAML format' do
    app = Shak::Application.new(
      'name' => 'Some App',
      'cookbook_name' => 'mycookbook',
    )
    io = StringIO.new

    serializer = Shak::Context::SerializeApplication.new(app)
    serializer.serialize(io)

    data = YAML.load(io.string)

    expect(data['name']).to eq('Some App')
    expect(data['cookbook_name']).to eq('mycookbook')
  end

end
