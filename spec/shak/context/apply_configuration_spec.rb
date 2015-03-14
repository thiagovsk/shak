require 'spec_helper'

require 'shak/repository'
require 'shak/context/apply_configuration'

describe Shak::Context::ApplyConfiguration do

  let(:repository) { Shak::Repository.new }
  let(:apply) { Shak::Context::ApplyConfiguration.new(repository) }

  it 'references repository' do
    expect(apply.repository).to be(repository)
  end

  it 'creates node attributes file' do
    expect(repository).to receive(:run_list).and_return(['recipe[shak]'])
    config_file = apply.send(:generate_json_attributes_file)
    data = JSON.load(File.read(config_file))

    expect(data).to eq({"run_list" => ["recipe[shak]"]})
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
