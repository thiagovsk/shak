require 'shak/version'
require 'commander'

module Shak

  class CLI

    include Commander::Methods

    def run
      program :name, 'shak'
      program :version, Shak::VERSION
      program :description, 'shak command line interface'

      # load subcommands
      Dir.glob(File.join(File.dirname(__FILE__), 'cli', '*.rb')).each do |f|
        instance_eval File.read(f), f
      end

      run!
    end

    def fail(message, rc=1)
      puts message
      exit rc
    end

  end

end

