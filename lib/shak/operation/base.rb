require 'shak/repository_disk_store'

module Shak
  module Operation
    class Base
      def store
        @store ||= Shak::RepositoryDiskStore.new
      end

      def repository
        @repository ||= store.read
      end
    end
  end
end
