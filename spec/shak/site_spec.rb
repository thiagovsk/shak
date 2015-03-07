require 'shak/site'
require 'shak/application'

describe Shak::Site do

  it 'has applications' do
    site = Shak::Site.new
    site.applications << Shak::Application.new
  end

end
