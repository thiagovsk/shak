require 'spec_helper'

require 'shak/cookbook'

describe Shak::Cookbook do

  it 'lists all cookbooks' do
    FileUtils.mkdir_p(@tmpdir + '/foo')
    FileUtils.mkdir_p(@tmpdir + '/bar')
    Shak.config.stub(:cookbooks_dir).and_return(@tmpdir)

    cookbooks = Shak::Cookbook.all
    expect(cookbooks.map(&:name).sort.reverse).to eq(['foo', 'bar'])
  end

end
