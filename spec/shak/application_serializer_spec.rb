require "spec_helper"

require 'stringio'
require 'yaml'

require 'shak/application'
require 'shak/application_serializer'

describe Shak::ApplicationSerializer do

  let(:serializer) { described_class.new }

  let(:input) do
    Shak::CookbookInput.new.tap do |i|
      i.text :field1
      i.text :field2
    end
  end

  it 'writes in YAML format' do
    app = Shak::Application.new(
      'name' => 'Some App',
      'cookbook_name' => 'mycookbook',
    )
    io = StringIO.new

    allow(app).to receive(:input).and_return(input)
    app.field1 = 'value1'
    app.field2 = 'value2'

    serializer.serialize(app, io)

    data = YAML.load(io.string)

    expect(data['name']).to eq('Some App')
    expect(data['cookbook_name']).to eq('mycookbook')
    expect(data['field1']).to eq('value1')
    expect(data['field2']).to eq('value2')
  end

  it 'reads YAML format' do
    data = {
      'name' => 'Some App',
      'cookbook_name' => 'mycookbook',
      'path' => '/',
      'field1' => 'value1',
    }.to_yaml
    allow_any_instance_of(Shak::Application).to receive(:input).and_return(input)

    app = serializer.read(StringIO.new(data))
    expect(app.name).to eq('Some App')
    expect(app.cookbook_name).to eq('mycookbook')
    expect(app.path).to eq('/')
    expect(app.field1).to eq('value1')

  end

end
