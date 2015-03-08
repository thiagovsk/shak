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

end
