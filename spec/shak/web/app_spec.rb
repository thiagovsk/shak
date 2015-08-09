require 'spec_helper'
require 'rack/test'

require 'shak/operation/install'
require 'shak/web/app'

describe Shak::Web::App do

  include Rack::Test::Methods
  let(:app) { Shak::Web::App }

  before do
    dont_really_run_commands

    installation = Shak::Operation::Install.new('static_site')
    installation.input_data = { 'hostname' => 'foo.com' }
    installation.perform
  end

  it 'lists installed apps' do
    get '/'
    expect(last_response).to match('http://foo.com')
  end

end
