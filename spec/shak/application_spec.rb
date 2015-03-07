require 'shak/application'

describe Shak::Application do

  it 'references the site' do
    site = Shak::Site.new
    app = Shak::Application.new
    app.site = site
    expect(app.site).to be(site)
  end

end
