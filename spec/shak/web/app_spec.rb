require 'spec_helper'
require 'rack/test'

require 'shak/web/app'

describe Shak::Web::App do

  include ShakOperationHelpers
  include Rack::Test::Methods
  let(:app) { Shak::Web::App }

  it 'lists installed apps' do
    install('static_site', 'hostname' => 'foo.com')
    get '/'
    expect(last_response).to match('http://foo.com')
  end

end
