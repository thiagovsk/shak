require 'shellwords'

module Shak

  class CommandFailed < Exception
    attr_reader :exit_status
    def initialize(msg, exit_status)
      super(msg)
      @exit_status = exit_status
    end
  end

  class << self

    def run(*args)
      puts format_cmd(args) if Shak.config.verbose
      system(*args)
      rc = $?.exitstatus
      if rc != 0
        raise CommandFailed.new('Command `%s` failed' % format_cmd(args), rc)
      end
    end

    def format_cmd(args)
      args.map { |s| Shellwords.escape(s) }.join(' ')
    end

  end
end

require "shak/version"
require 'shak/config'
