require 'shak/repository'
require 'shak/site'

describe Shak::Repository do

  let(:repository) { Shak::Repository.new }

  let(:site) { Shak::Site.new(hostname: 'foo.com') }

  it 'adds a new site' do
    repository.add(site)
    expect(repository.count).to eq(1)
  end

  it 'removes a site' do
    repository.add(site)
    repository.remove(site.hostname)
    expect(repository.count).to eq(0)
  end

  it 'finds a site' do
    repository.add(site)

    found = repository.find(site.hostname)
    expect(found).to eq(site)
  end

  it 'updates a site' do
    site.name = 'My Site'
    repository.add(site)

    other_site = site.dup
    other_site.name = 'Our site'

    repository.update(site.hostname, other_site)

    stored = repository.find(site.hostname)
    expect(stored).to be(other_site)
  end

end
