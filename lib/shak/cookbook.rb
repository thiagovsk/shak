require 'shak'

module Shak

  class Cookbook

    attr_reader :name

    class << self

      def all
        Dir.chdir(Shak.config.cookbooks_dir) do
          Dir.glob('*').map do |c|
            new(c)
          end
        end
      end

    end

    def inspect
      "#<Cookbook:#{name}>"
    end

    def to_s
      name
    end

    private

    def initialize(name)
      @name = name
    end

  end

end
