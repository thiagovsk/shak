require 'shak/operation/install'

command :install do |c|
  c.syntax = 'shak install [OPTIONS] APP [APP ...]'
  c.description = 'installs a new application'
  c.action do |args,options|
    install = Shak::Operation::Install.new(args)
    install.perform
  end
end
