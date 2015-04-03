require "spec_helper"

require 'securerandom'

require 'shak/repository_disk_store'

describe Shak::RepositoryDiskStore do

  let(:store) { Shak::RepositoryDiskStore.new }

  def new_application(path)
    Shak::Application.new(
      :name => 'Application at ' + path,
      :cookbook_name => path,
      :path => '/' + path,
    )
  end

  let(:app1) { new_application('app1') }
  let(:app2) { new_application('app2') }

  let(:site) do
    site = Shak::Site.new(
      :hostname => 'foo.com',
      :name => 'Foo',
    )

    site.applications.add app1
    site.applications.add app2

    site
  end

  let(:repository) do
    repository = Shak::Repository.new
    repository.sites.add(site)
    repository
  end

  let(:repository_files) do
    Dir.chdir(Shak.config.data_dir) { Dir.glob('**/*') }
  end

  it 'writes a repository' do
    store.write(repository)
    expect(repository_files).to include('foo.com.yaml')
    expect(repository_files).to include('foo.com/_app1.yaml')
    expect(repository_files).to include('foo.com/_app2.yaml')
  end

  it 'deletes removed sites' do
    store.write(repository)
    repository.sites.remove(site)
    store.write(repository)

    expect(repository_files).to eq([])
  end

  it 'deletes removed apps' do
    store.write(repository)
    site.applications.remove(app2)
    store.write(repository)

    expect(repository_files).to_not include('foo.com/_app2.yaml')
  end

  context 'reading from disk' do
    before(:each) do
      store.write(repository)
      @from_disk = store.read
    end

    it 'reads correctly' do
      expect(@from_disk).to eq(repository)
    end

    it 'assigns site in applications' do
      site = @from_disk.sites.find('foo.com')
      app = site.find('/app1')
      expect(app.site).to eq(site)
    end

  end

end
