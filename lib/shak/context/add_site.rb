require 'shak/context/base'
require 'shak/site'

module Shak
  module Context
    class AddSite < Base

      class SiteAlreadyExists < Exception
        def initialize(hostname)
          super("Site %s already exists" % hostname)
        end
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
