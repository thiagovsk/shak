require 'shak/context/base'

module Shak
  module Context
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
