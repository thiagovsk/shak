require 'shak/operation/install'

describe Shak::Operation::Install do

  let(:install) { described_class.new(['app1']) }
  let(:repository) { install.send(:repository) }
  let(:repository_from_disk) { described_class.new(['app1']).send(:repository) }

  before(:each) do
    fake_cookbook('app1')
    dont_really_run_commands

    install.perform
  end

  it 'modifies repository' do
    expect(repository.all.size).to eq(1)
    expect(repository.all.first.name).to eq('app1')
  end

  it 'writes repository do disk' do
    expect(repository_from_disk.all.size).to eq(1)
    expect(repository.all.first.name).to eq('app1')
  end

end
