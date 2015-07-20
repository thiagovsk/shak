require 'shak/operation/install'
require 'shak/operation/config'

describe Shak::Operation::Config do

  before(:each) do
    fake_cookbook('app1', input)
    dont_really_run_commands
  end

  let(:input) do
    Shak::CookbookInput.new.tap do |i|
      i.text :text_field
    end
  end

  it 'updates the parameters of an existing application' do
    # install application
    install = Shak::Operation::Install.new('app1')
    install.input_data = { text_field: 'foo' }
    install.perform

    # update application
    appid = install.send(:repository).all.last.id
    config = Shak::Operation::Config.new(appid)
    config.input_data = { text_field: 'bar' }
    config.perform

    # retrieve application from storage
    application = Shak::Operation::Base.new.send(:repository).find(appid)
    expect(application.text_field). to eq('bar')
  end

end
