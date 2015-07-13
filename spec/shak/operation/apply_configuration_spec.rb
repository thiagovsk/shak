require 'spec_helper'

require 'shak/repository'
require 'shak/application'
require 'shak/operation/apply_configuration'

describe Shak::Operation::ApplyConfiguration do

  let(:apply) { Shak::Operation::ApplyConfiguration.new }
  let(:repository) { apply.send(:repository) }

  context 'creating node attributes file' do
    before(:each) do
      allow(repository).to receive(:run_list).and_return(['recipe[shak]'])

      app = Shak::Application.new('static_site')
      repository.add app
    end

    let(:config_file) { apply.send(:generate_json_attributes_file) }
    let(:data) { JSON.load(File.read(config_file)) }

    it 'adds shak recipe to run_list' do
      expect(data['run_list']).to include("recipe[shak]")
    end

    it 'adds applications' do
      apps = data['applications'].map { |a| a['name'] }
      expect(apps).to include('static_site')
    end

    it 'adds application id' do
      app = data['applications'].first
      expect(app.keys).to include('id')
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

    apply.perform
  end

end
