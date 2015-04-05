require 'shellwords'

module Shak

  class << self

    class CommandFailed < Exception; end

    def run(*args)
      puts format_cmd(args) if Shak.config.verbose
      system(*args)
      if $?.exitstatus != 0
        raise CommandFailed.new('Command `%s` failed' % format_cmd(args))
      end
    end

    def format_cmd(args)
      args.map { |s| Shellwords.escape(s) }.join(' ')
    end

  end
end

require "shak/version"
require 'shak/config'
