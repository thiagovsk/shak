require 'listen'

require 'shak/operation/apply_configuration'

command :deploy do |c|
  c.syntax = 'shak deploy'
  c.description = '(re-)applies configuration'
  c.option '-l', '--listen', 'Listen for changes in repository, re-deploys when they happen'
  c.action do |args,options|
    fail_usage(c) if args.size != 0

    apply_configuration = Shak::Operation::ApplyConfiguration.new

    if options.listen
      apply_configuration.listen
    else
      apply_configuration.perform
    end
  end
end

