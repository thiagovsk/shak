require "spec_helper"

require 'shak/site'
require 'shak/application'

describe Shak::Site do

  it 'has applications' do
    site = Shak::Site.new
    site.applications.add(Shak::Application.new)
    expect(site.applications.count).to eq(1)
  end

end
