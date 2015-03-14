require "spec_helper"

require 'shak/site_serializer'
require 'shak/site'
require 'stringio'

describe Shak::SiteSerializer do

  it 'writes in YAML format' do
    site = Shak::Site.new(
      hostname: 'foo.com',
      name: 'Foo',
      ssl: true,
      www: 'force',
    )
    serializer = Shak::SiteSerializer.new
    io = StringIO.new
    serializer.serialize(site, io)

    data = YAML.load(io.string)
    expect(data['hostname']).to eq('foo.com')
    expect(data['name']).to eq('Foo')
    expect(data['ssl']).to eq(true)
    expect(data['www']).to eq('force')
  end

end
