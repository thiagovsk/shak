require "spec_helper"

require 'shak/site'
require 'shak/application'

describe Shak::Site do

  it 'has applications' do
    site = Shak::Site.new
    site.applications.add(Shak::Application.new)
    expect(site.applications.count).to eq(1)
  end

  context 'comparing for equality' do

    let(:site1) do
      Shak::Site.new
    end
    let(:site2) { site1.dup }

    it 'equals when both are empty' do
      expect(Shak::Site.new).to eq(Shak::Site.new)
    end

    it 'is not equal when attributes change' do
      site2.name = 'Foo bar'
      expect(site2).to_not eq(site1)
    end

    it 'is not equal when applications change' do
      site2.applications.add(Shak::Application.new)
      expect(site2).to_not eq(site1)
    end

  end

end
