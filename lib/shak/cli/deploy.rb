require 'shak/operation/apply_configuration'

command :deploy do |c|
  c.syntax = 'shak deploy'
  c.description = '(re-)applies configuration'
  c.action do |args,options|
    fail_usage if args.size != 0

    apply_configuration = Shak::Operation::ApplyConfiguration.new
    apply_configuration.perform
  end
end

