require "spec_helper"

require 'securerandom'

require 'shak/context/store_repository'
require 'shak/repository'
require 'shak/site'
require 'shak/application'

describe Shak::Context::StoreRepository do

  let(:store) { Shak::Context::StoreRepository.new }

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

  it 'reads from disk' do
    store.write(repository)
    from_disk = store.read
    expect(from_disk).to eq(repository)
  end

end
