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

  it 'uses path as id' do
    app = Shak::Application.new(path: '/foobar')
    expect(app.id).to eq('/foobar')
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

  context 'referencing cookbook' do
    let(:app) { Shak::Application.new(cookbook_name: 'shak') }
    let(:cookbook) { Shak::Cookbook.send(:new, 'foo') }

    it 'returns an Shak::Cookbook instance' do
      expect(app.cookbook).to be_a(Shak::Cookbook)
    end

    it 'sets a coobook' do
      app.cookbook = cookbook
      expect(app.cookbook).to be(cookbook)
      expect(app.cookbook_name).to eq(cookbook.name)
    end
  end

end
