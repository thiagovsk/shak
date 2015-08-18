require 'forwardable'

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

    METADATA_FIELDS = [
      :description,
      :long_description,
      :version,
      :depends,
      :maintainer,
      :maintainer_email,
      :license,
    ]
    attr_reader :metadata

    extend Forwardable
    delegate METADATA_FIELDS => :metadata

    private

    class Metadata
      def initialize(path)
        file = File.join(path, 'metadata.rb')
        instance_eval(File.read(file), file, 1) if File.exists?(file)
      end
      ([:name] + METADATA_FIELDS).each do |attr|
        define_method(attr) do |v=nil|
          instance_variable_set("@#{attr}", v) if v
          instance_variable_get("@#{attr}")
        end
      end
    end

    def initialize(name)
      @name = name
      @path = File.join(self.class.path, name)
      @metadata = Metadata.new(@path)
    end

  end

end
