require 'spec_helper'

require 'shak/operation/add_site'

describe Shak::Operation::AddSite do

  let(:add_site) { Shak::Operation::AddSite.new }
  let(:repository) { add_site.repository }

  it 'contains a repository instance' do
    expect(repository).to be_a(Shak::Repository)
  end

  it 'adds a site to the repository' do
    add_site.add!('foo.com')
    expect(repository.sites.find('foo.com')).to be_a(Shak::Site)
  end

  it 'has a store instance' do
    expect(add_site.store).to be_a(Shak::RepositoryDiskStore)
  end

  it 'writes the repository to disk' do
    expect(add_site.store).to receive(:write).with(repository)
    add_site.add!('foo.com')
  end

  it 'throws exception if site already exists' do
    expect(lambda do
      2.times do
        # use a fresh instance to emulate multiple executions
        add_site = Shak::Operation::AddSite.new
        add_site.add!('foo.com')
      end
    end).to raise_error(Shak::Operation::AddSite::SiteAlreadyExists)
  end

  it 'processes options' do
    add_site.add!('foo.com', name: 'My site', ssl: true, www: 'force')
    site = repository.find('foo.com')
    expect(site.name).to eq('My site')
    expect(site.ssl).to eq(true)
    expect(site.www).to eq('force')
  end

end
