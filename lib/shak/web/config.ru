require 'sprockets'
require 'bootstrap-sass'
require 'coffee_script'

require 'shak/web/app'

environment = Sprockets::Environment.new
environment.append_path File.expand_path('../assets', __FILE__)
# on Debian use jquery from the system
'/usr/share/javascript/jquery'.tap do |path|
  if File.exist?(path)
    environment.append_path(path)
  end
end

map '/assets' do
  run environment
end

map '/fonts' do
  run environment
end

map '/' do
  run Shak::Web::App
end
