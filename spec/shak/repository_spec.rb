require "spec_helper"

require 'shak/repository'
require 'shak/site'

describe Shak::Repository do

  let(:repository) { Shak::Repository.new }

  let(:site) { Shak::Site.new(hostname: 'foo.com') }
  let(:other_site) { Shak::Site.new(hostname: 'bar.com') }

  it 'adds a new site' do
    repository.sites.add(site)
    expect(repository.sites.count).to eq(1)
  end

  context 'removes a site' do
    before(:each) do
      repository.sites.add(site)
      repository.sites.remove(site.hostname)
    end
    it 'removes from the list' do
      expect(repository.sites.count).to eq(0)
    end
    it 'keeps a list of removed sites' do
      expect(repository.sites.removed).to include(site.hostname)
    end
  end

  it 'finds a site' do
    repository.sites.add(site)

    found = repository.sites.find(site.hostname)
    expect(found).to eq(site)
  end

  it 'updates a site' do
    site.name = 'My Site'
    repository.sites.add(site)

    other_site = site.dup
    other_site.name = 'Our site'

    repository.sites.add(other_site)

    stored = repository.sites.find(site.hostname)
    expect(stored).to be(other_site)
  end

  context 'producing a run list' do
    it 'runs each application recipe, and shak at the end' do
      repository.sites.add(site)
      repository.sites.add(other_site)
      allow(site).to receive(:run_list).and_return(['recipe[app1]'])
      allow(other_site).to receive(:run_list).and_return(['recipe[app2]'])
      expect(repository.run_list).to eq(['recipe[app1]', 'recipe[app2]', 'recipe[shak]'])
    end
  end

end
