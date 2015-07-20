require 'shak/operation/config'

command :config do |c|
  c.syntax = 'shak config APPID [key=value ...]'
  c.description = '(re)configures an application'
  c.action do |args,options|
    # FIXME duplicates logic from install
    input = args.select { |a| a =~ /=/ }.inject({}) do |acc,obj|
      key, value = obj.split('=')
      acc[key] = value
      acc
    end
    args.reject! { |a| a =~ /=/ }

    appid = args.shift

    if args.size > 0
      fail_usage c
    end

    config = Shak::Operation::Config.new(appid)
    config.input_data = input
    config.perform

    apply = Shak::Operation::ApplyConfiguration.new
    apply.perform
  end
end
