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

  it 'generates sequential identifiers' do
    app1 = Shak::Application.new('foo')
    app_with_id = Shak::Application.new('foo', 'mycustomid')
    app2 = Shak::Application.new('foo')


    repository.add(app1)
    repository.add(app_with_id)
    repository.add(app2)

    expect(app1.id).to eq("foo_1")
    expect(app2.id).to eq("foo_2")
  end

  it 'does not accept duplicated ids' do
    app1 = Shak::Application.new('foo', 'myid')
    app2 = Shak::Application.new('foo', 'myid')
    repository.add(app1)

    expect(lambda { repository.add(app2)}).to raise_error(ArgumentError)
  end

  it 'does not accept ids larger than 16 characters' do
    large_id = Shak::Application.new('foo', 'x' * 17)
    expect(lambda { repository.add(large_id) }).to raise_error(ArgumentError)
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
