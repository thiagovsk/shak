require 'shak/application'
require 'shak/context/base'

module Shak
  module Context
    class AddApp < Base

      class SiteDoesNotExist < Exception
        def initialize(hostname)
          super("Site %s does not exist" % hostname)
        end
      end
      class PathAlreadyInUse < Exception
        def initialize(path)
          super("Path %s is already in use by another application" % path)
        end
      end

      def add!(hostname, appname, path, extra_data = {})
        site = repository.find(hostname)
        raise SiteDoesNotExist.new(hostname) if site.nil?

        existing_app = site.find(path)
        raise PathAlreadyInUse.new(path) if existing_app

        data = { cookbook_name: appname, path: path }.merge(extra_data)
        app = Shak::Application.new(data)
        site.applications.add(app)

        store.write(repository)
      end

    end
  end
end
