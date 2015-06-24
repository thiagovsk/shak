require 'shak/operation/base'

module Shak
  module Operation
    class Traverse < Base

      def each_app
        repository.each do |site|
          site.each do |app|
            yield app
          end
        end
      end

    end
  end
end
