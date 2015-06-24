require 'spec_helper'

require 'shak/operation/traverse'

describe Shak::Operation::Traverse do

  let(:traverse) { described_class.new }
  let(:repository) { traverse.repository }

  it 'traverses all sites' do
    site1 = Shak::Site.new(hostname: 'foo.com')
    app1 = Shak::Application.new(cookbook_name: 'app1')
    site1.applications.add(app1)
    repository.sites.add(site1)

    site2 = Shak::Site.new(hostname: 'bar.com')
    app2 = Shak::Application.new(cookbook_name: 'app2')
    site2.applications.add(app2)
    repository.sites.add(site2)

    apps = []
    traverse.each_app { |app| apps << app }
    expect(apps).to eq([app1, app2])
  end

end
