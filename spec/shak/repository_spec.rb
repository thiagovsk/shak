require "spec_helper"

require 'shak/application'
require 'shak/repository'

describe Shak::Repository do

  let(:repository) { Shak::Repository.new }

  let(:application) { Shak::Application.new('app1') }
  let(:another_application) { Shak::Application.new('app2')}

  it 'adds a new application' do
    repository.add(application)
    expect(repository.count).to eq(1)
  end

  context 'producing a run list' do
    it 'runs each application recipe, and shak at the end' do
      repository.add(application)
      repository.add(another_application)

      allow(application).to receive(:run_list).and_return(['recipe[app1]'])
      allow(another_application).to receive(:run_list).and_return(['recipe[app2]'])
      expect(repository.run_list).to eq(['recipe[app1]', 'recipe[app2]', 'recipe[shak]'])
    end
  end

end
