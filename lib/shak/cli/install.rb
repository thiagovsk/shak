require 'shak/operation/install'

command :install do |c|

  class UI
    def display_error(error)
      puts 'E: %s (field: %s, value: %s)' % [error.message, error.name, error.value]
    end
    def abort
      exit(1)
    end
  end

  c.syntax = 'shak install [OPTIONS] APP [key=value ...]'
  c.description = 'installs a new application'
  c.action do |args,options|
    input = args.select { |a| a =~ /=/ }.inject({}) do |acc,obj|
      key, value = obj.split('=')
      acc[key] = value
      acc
    end
    args.reject! { |a| a =~ /=/ }
    if args.size != 1
      fail_usage c
    end
    install = Shak::Operation::Install.new(args.first)
    install.input_data = input
    install.user_interface = UI.new
    install.perform
  end
end
