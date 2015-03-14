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

  context 'producing a run list' do
    def app(c)
      Shak::Application.new.tap do |a|
        a.cookbook = Shak::Cookbook.send(:new, c)
        a.path = "/" + c
      end
    end
    let(:site) do
      Shak::Site.new
    end

    it 'lists cookbooks from each app' do
      site.applications.add(app('app1'))
      site.applications.add(app('app2'))

      expect(site.run_list).to eq(['recipe[app1]', 'recipe[app2]'])
    end
  end

end
