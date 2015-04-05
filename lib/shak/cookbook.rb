require 'shak'
require 'shak/cookbook_input'

module Shak

  class Cookbook

    attr_reader :name

    class << self

      def path
        Shak.config.cookbooks_dir
      end

      def all
        Dir.chdir(path) do
          Dir.glob('*').map do |c|
            new(c)
          end
        end
      end

      def [](cookbook_name)
        if !File.directory?(File.join(path, cookbook_name))
          raise ArgumentError.new("No cookbook named \"%s\"" % cookbook_name)
        end
        new(cookbook_name)
      end

    end

    def inspect
      "#<Cookbook:#{name}>"
    end

    def to_s
      name
    end

    attr_reader :path

    def input
      Shak::CookbookInput.new.tap do |input|
        input_file = File.join(path, 'input.rb')
        if File.exists?(input_file)
          input.instance_eval(File.read(input_file), input_file)
        end
      end
    end

    private

    def initialize(name)
      @name = name
      @path = File.join(self.class.path, name)
    end

  end

end
