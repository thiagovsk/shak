require 'spec_helper'

require 'shak/site'
require 'shak/operation/add_app'

describe Shak::Operation::AddApp do

  let(:add_app) do
    described_class.new.tap do |a|
      a.repository.sites.add Shak::Site.new(hostname: 'foo.com')
    end
  end
  let(:empty_add_app) { described_class.new }

  it 'has a store instance' do
    expect(add_app.store).to be_a(Shak::RepositoryDiskStore)
  end

  it 'has a repository instance' do
    expect(add_app.repository).to be_a(Shak::Repository)
  end

  it 'needs to add the site first' do
    expect(lambda do
      empty_add_app.add!('foo.com', 'myapp', '/')
    end).to raise_error(Shak::Operation::AddApp::SiteDoesNotExist)
  end

  context 'adding the app' do

    before(:each) do
      add_app.add!('foo.com', 'static_site', '/')
      @app = add_app.repository.find('foo.com').applications.find('/')
    end

    it 'adds a Shak::Application' do
      expect(@app).to be_a(Shak::Application)
    end

    it 'uses app name as cookbook name' do
      expect(@app.cookbook_name).to eq('static_site')
    end
  end

  it 'writes repository to disk' do
    expect(add_app.store).to receive(:write).with(add_app.repository)
    add_app.add!('foo.com', 'static_site', '/')
  end

  it 'does not allow two apps on the same path' do
    expect(lambda do
    add_app.add!('foo.com', 'static_site', '/')
    add_app.add!('foo.com', 'dynamic_site', '/')
    end).to raise_error(Shak::Operation::AddApp::PathAlreadyInUse)
  end

end
