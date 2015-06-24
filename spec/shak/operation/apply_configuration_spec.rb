require 'spec_helper'

require 'shak/repository'
require 'shak/site'
require 'shak/application'
require 'shak/operation/apply_configuration'

describe Shak::Operation::ApplyConfiguration do

  let(:apply) { Shak::Operation::ApplyConfiguration.new }
  let(:repository) { apply.repository }

  it 'references repository' do
    expect(apply.repository).to be(repository)
  end

  context 'creating node attributes file' do
    before(:each) do
      allow(repository).to receive(:run_list).and_return(['recipe[shak]'])

      site = Shak::Site.new(hostname: 'foo.com')
      app = Shak::Application.new(cookbook_name: 'static_site', site: site)
      site.applications.add app
      repository.sites.add site
    end

    let(:config_file) { apply.send(:generate_json_attributes_file) }
    let(:data) { JSON.load(File.read(config_file)) }

    it 'adds shak recipe to run_list' do
      expect(data['run_list']).to include("recipe[shak]")
    end

    it 'adds hostname of sites' do
      hostnames = data['sites'].map { |s| s['hostname'] }
      expect(hostnames).to include('foo.com')
    end

    it 'adds applications' do
      apps = data['applications'].map { |a| a['cookbook_name'] }
      expect(apps).to include('static_site')
    end

    it 'adds application path' do
      app = data['applications'].first
      expect(app.keys).to include("path")
    end

    it 'adds application id' do
      app = data['applications'].first
      expect(app.keys).to include('id')
    end

    it 'includes site data in applications' do
      app = data['applications'].first
      expect(app['site']).to be_a(Hash)
      expect(app['site'].keys).to include("hostname")
    end

  end

  it 'creates solo config file' do
    solo_config = apply.send(:generate_solo_configuration)
    config = File.read(solo_config)

    expect(config).to match("cookbook_path '#{Shak.config.cookbooks_dir}'")
  end

  it 'runs chef-solo' do
    expect(apply).to receive(:generate_json_attributes_file).and_return('/path/to/json')
    expect(apply).to receive(:generate_solo_configuration).and_return('/path/to/config')

    expect(Shak).to receive(:run).with('sudo', 'chef-solo', '--json-attributes', '/path/to/json', '--config', '/path/to/config')

    apply.apply!
  end

end
