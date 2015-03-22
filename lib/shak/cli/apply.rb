require 'shak/context/apply_configuration'

command :apply do |c|
  c.syntax = 'shak apply [OPTIONS]'
  c.description = 'Applies the current configuration to the system'
  c.action do |args,options|
    unless args.empty?
      fail 'usage: ' + c.syntax
    end

    configuration = Shak::Context::ApplyConfiguration.new
    configuration.apply!
  end

end
