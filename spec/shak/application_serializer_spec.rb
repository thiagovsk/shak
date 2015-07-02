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
    app = Shak::Application.new('someapp')
    io = StringIO.new

    allow(app).to receive(:input).and_return(input)
    app.field1 = 'value1'
    app.field2 = 'value2'

    serializer.serialize(app, io)

    data = YAML.load(io.string)

    expect(data['name']).to eq('someapp')
    expect(data['field1']).to eq('value1')
    expect(data['field2']).to eq('value2')
  end

  it 'reads YAML format' do
    data = {
      'name' => 'someapp',
      'field1' => 'value1',
    }.to_yaml
    allow_any_instance_of(Shak::Application).to receive(:input).and_return(input)

    app = serializer.read(StringIO.new(data))
    expect(app.name).to eq('someapp')
    expect(app.field1).to eq('value1')

  end

  it 'does a roundtrip' do
    allow_any_instance_of(Shak::Application).to receive(:input).and_return(input)

    original = Shak::Application.new('foobar')

    write_buffer = StringIO.new
    serializer.serialize(original, write_buffer)

    read_buffer = StringIO.new(write_buffer.string)
    deserialized = serializer.read(read_buffer)

    expect(deserialized).to eq(original)
  end

end
