require 'sprockets'
require 'bootstrap-sass'

require 'shak/web/app'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path File.expand_path('../assets', __FILE__)
  run environment
end

map '/' do
  run Shak::Web::App
end
