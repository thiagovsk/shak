require 'spec_helper'

require 'shak/cookbook'

describe Shak::Cookbook do

  it 'lists all cookbooks' do
    FileUtils.mkdir_p(@tmpdir + '/foo')
    FileUtils.mkdir_p(@tmpdir + '/bar')
    allow(Shak.config).to receive(:cookbooks_dir).and_return(@tmpdir)
    cookbooks = Shak::Cookbook.all
    expect(cookbooks.map(&:name).sort.reverse).to eq(['foo', 'bar'])
  end

  context 'returning cookbook by name' do
    it 'works if cookbook exists' do
      expect(Shak::Cookbook['shak']).to be_a(Shak::Cookbook)
    end
    it 'fails if cookbook does not exist' do
      name = 'incrediblyunlikelycookbookname'
      expect(lambda { Shak::Cookbook[name] }).to raise_error(ArgumentError)
    end
  end

  it 'has a path' do
    expect(Shak::Cookbook['shak'].path).to be_a(String)
  end

end
