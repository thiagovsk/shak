require 'spec_helper'

require 'shak/operation/install'

describe Shak::Operation::Install do

  let(:ui) { Object.new }
  let(:install) { described_class.new('app1') }
  let(:application) { install.application }
  let(:repository) { install.send(:repository) }
  let(:repository_from_disk) { described_class.new(['app1']).send(:repository) }

  before(:each) do
    fake_cookbook('app1')
    dont_really_run_commands
  end

  it 'modifies repository' do
    install.perform
    expect(repository.all.size).to eq(1)
    expect(repository.all.first.name).to eq('app1')
  end

  it 'writes repository do disk' do
    install.perform
    expect(repository_from_disk.all.size).to eq(1)
    expect(repository.all.first.name).to eq('app1')
  end

  it 'passes input to application' do
    input = Shak::CookbookInput.new.tap do |i|
      i.text :foo
    end
    allow(application).to receive(:input).and_return(input)

    install.input_data = { 'foo' => 'bar' }
    expect(application.input_data).to eq({'foo' => 'bar'})
  end

  class TestUI
    def errors
      @errors ||= []
    end
    def display_error(error)
      errors << error
    end
    def abort
      @aborted = true
    end
    def aborted?
      @aborted
    end
  end

  it 'aborts on invalid input' do
    input = Shak::CookbookInput.new.tap do |i|
      i.text :foo do
        mandatory
      end
    end
    allow(application).to receive(:input).and_return(input)
    allow(install).to receive(:apply_configuration)
    allow(install).to receive(:puts)

    ui = install.user_interface = TestUI.new

    install.perform

    expect(ui.errors).to_not be_empty
    expect(ui).to be_aborted
  end

end
