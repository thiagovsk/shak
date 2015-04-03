require 'spec_helper'

require 'shak/repository'
require 'shak/site'
require 'shak/application'
require 'shak/context/apply_configuration'

describe Shak::Context::ApplyConfiguration do

  let(:apply) { Shak::Context::ApplyConfiguration.new }
  let(:repository) { apply.repository }

  it 'references repository' do
    expect(apply.repository).to be(repository)
  end

  context 'creating node attributes file' do
    before(:each) do
      allow(repository).to receive(:run_list).and_return(['recipe[shak]'])
      repository.sites.add Shak::Site.new(hostname: 'foo.com')
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

  end

  it 'creates solo config file' do
    solo_config = apply.send(:generate_solo_configuration)
    config = File.read(solo_config)

    expect(config).to match("cookbook_path '#{Shak.config.cookbooks_dir}'")
  end

  it 'runs chef-solo' do
    expect(apply).to receive(:generate_json_attributes_file).and_return('/path/to/json')
    expect(apply).to receive(:generate_solo_configuration).and_return('/path/to/config')

    expect(apply).to receive(:system).with('sudo', 'chef-solo', '--json-attributes', '/path/to/json', '--config', '/path/to/config')

    apply.apply!
  end

end
