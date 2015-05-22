require 'shak'
require 'shak/version'
require 'commander'

module Shak

  class CLI

    include Commander::Methods

    def run
      program :name, 'shak'
      program :version, Shak::VERSION
      program :description, 'shak command line interface'

      global_option('-v', '--verbose') do
        Shak.config.verbose = true
      end

      # load subcommands
      Dir.glob(File.join(File.dirname(__FILE__), 'cli', '*.rb')).each do |f|
        instance_eval File.read(f), f
      end

      begin
        run!
      rescue Shak::CommandFailed => ex
        puts "E: #{ex.message}"
        exit ex.exit_status
      end

      finish_pager
    end

    def fail(message, rc=1)
      puts message
      exit rc
    end

    def fail_usage(command)
      fail 'usage: ' + command.syntax
    end

    def parse_extra_data(args)
      args.inject({}) do |acc,arg|
        key, value = arg.split('=')
        acc[key] = value
        acc
      end
    end

    def pager
      @pager ||= IO.popen(pager_environment, ['pager'], 'w')
    end

    def pager_environment
      {
        'LESS' => '-FRSX', # special handling for less(1)
      }
    end

    def finish_pager
      @pager.close if @pager
    end

  end

end

