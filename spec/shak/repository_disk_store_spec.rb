require "spec_helper"

require 'securerandom'

require 'shak/repository_disk_store'

describe Shak::RepositoryDiskStore do

  let(:store) { Shak::RepositoryDiskStore.new }

  before(:each) do
    allow_any_instance_of(Shak::Application).to receive(:input).and_return(Shak::CookbookInput.new)
  end
  let(:app1) { Shak::Application.new('app1') }
  let(:app2) { Shak::Application.new('app2') }

  let(:repository) do
    Shak::Repository.new.tap do |r|
      r.add(app1)
      r.add(app2)
    end
  end

  let(:repository_files) do
    Dir.chdir(Shak.config.repository_dir) { Dir.glob('**/*') }
  end

  it 'writes a repository' do
    store.write(repository)
    expect(repository_files).to include(app1.id + '.yaml')
    expect(repository_files).to include(app2.id + '.yaml')
  end

  it 'deletes removed applications' do
    store.write(repository)
    repository.remove(app1)
    repository.remove(app2)
    store.write(repository)

    expect(repository_files).to eq([])
  end

  context 'reading from disk' do
    before(:each) do
      store.write(repository)
      @from_disk = store.read
    end

    it 'reads correctly' do
      expect(@from_disk).to eq(repository)
    end

    it 'reads application timestamps' do
      timestamps = @from_disk.map(&:timestamp).map(&:class).uniq
      expect(timestamps).to eq([Time])
    end
  end

  context 'marking deployment timestamp' do
    it 'creates timestamp file' do
      store.add_deploy_timestamp
      expect(File).to exist(store.deploy_timestamp_file)
    end
    it 'reads timestamp file' do
      store.add_deploy_timestamp

      from_disk = store.read
      expect(from_disk.timestamp).to be_a(Time)
    end
  end

end
