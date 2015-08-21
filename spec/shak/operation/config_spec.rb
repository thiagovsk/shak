require 'spec_helper'

require 'shak/operation/install'
require 'shak/operation/config'

describe Shak::Operation::Config do

  it 'updates the parameters of an existing application' do
    # install application
    install = Shak::Operation::Install.new('static_site')
    install.input_data = { hostname: 'foo.com' }
    install.perform

    appid = install.send(:repository).all.last.id

    # update application
    config = Shak::Operation::Config.new(appid)
    config.input_data = { hostname: 'bar.com' }
    config.perform

    # retrieve application from storage
    application = Shak::Operation::Base.new.send(:repository).find(appid)
    expect(application.hostname). to eq('bar.com')
  end

end
