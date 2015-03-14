require "spec_helper"

require 'shak/application'
require 'shak/site'

describe Shak::Application do

  it 'references the site' do
    site = Shak::Site.new
    app = Shak::Application.new
    app.site = site
    expect(app.site).to be(site)
  end

  context 'uses path as identifier' do
    let(:app) { Shak::Application.new }

    it 'turns / into _' do
      app.path = '/'
      expect(app.id).to eq('_')
    end

    it 'turns /foo into _foo' do
      app.path = '/foo'
      expect(app.id).to eq('_foo')
    end
  end

  context 'comparing for equality' do

    let(:app1) do
      app1 = Shak::Application.new(
        name: 'My app',
        cookbook_name: 'myapp',
        path: '/myapp'
      )
    end
    let(:app2) { app1.dup }

    it 'is equal if attributes are equal' do
      expect(app2).to eq(app1)
    end

    it 'is not equal if attributes changes' do
      app2.name = 'blablabla'
      expect(app2).to_not eq(app1)
    end

    it 'is not equal if cookbook data changes' do
      app2.cookbook_data = { 'foo' => 'bar' }
      expect(app2).to_not eq(app1)
    end
  end

end
