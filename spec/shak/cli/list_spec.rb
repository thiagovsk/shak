require 'spec_helper'

describe 'shak install' do

  include ShakOperationHelpers
  include ShakCLIHelpers

  it 'lists installed apps' do
    install('static_site', 'hostname' => 'foo.com')
    sh 'shak list'
    expect(stdout).to match('foo.com')
  end

end
