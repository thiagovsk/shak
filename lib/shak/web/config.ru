require 'sprockets'
require 'bootstrap-sass'
require 'coffee_script'

require 'shak/web/app'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path File.expand_path('../assets', __FILE__)

  # on Debian use jquery from the system
  '/usr/share/javascript/jquery'.tap do |path|
    if File.exist?(path)
      environment.append_path(path)
    end
  end

  run environment
end

map '/' do
  run Shak::Web::App
end
