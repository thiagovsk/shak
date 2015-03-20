require 'shak/site'
require 'shak/repository_disk_store'

module Shak
  module Context
    class AddSite

      class SiteAlreadyExists < Exception
        def initialize(hostname)
          super("Site %s already exists" % hostname)
        end
      end

      attr_reader :store

      def initialize
        @store = Shak::RepositoryDiskStore.new
      end

      def repository
        @repository ||= store.read
      end

      def add!(hostname, options = {})
        if repository.find(hostname)
          raise SiteAlreadyExists.new(hostname)
        end

        final_options = options.merge(hostname: hostname)
        site = Shak::Site.new(final_options)

        repository.sites.add(site)
        store.write(repository)
      end

    end
  end
end
