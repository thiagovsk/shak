require 'shak/repository'
require 'shak/context/apply_configuration'

command :apply do |c|
  c.syntax = 'shak apply [OPTIONS]'
  c.description = 'Applies the current configuration to the system'
  c.action do |args,options|
    unless args.empty?
      fail 'usage: ' + c.syntax
    end

    repository = Shak::Repository.new
    configuration = Shak::Context::ApplyConfiguration.new(repository)
    configuration.apply!
  end

end
