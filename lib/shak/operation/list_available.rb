require_relative 'base'
require 'shak/cookbook'

module Shak
  module Operation
    class ListAvailable < Base
      def initialize(&block)
        @callback = block
      end

      def perform
        Shak::Cookbook.all.each do |cookbook|
          @callback.call({
            name: cookbook.name,
            description: cookbook.description,
            long_description: cookbook.long_description,
          }) unless ['shak', 'ssl'].include?(cookbook.name)
        end
      end
    end
  end
end
