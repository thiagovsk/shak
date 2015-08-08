require 'slim'

# debug options for development
if ENV['RACK_ENV'] == 'development'
  Slim::Engine.set_default_options pretty: true
end
