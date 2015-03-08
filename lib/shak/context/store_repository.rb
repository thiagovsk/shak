require 'fileutils'

require 'shak'
require 'shak/context/serialize_site'
require 'shak/context/serialize_application'

module Shak
  module Context
    class StoreRepository

      # Writes +repository+ to disk.
      def write(repository)
        repository.sites.each do |site|
          write_site(site)
          site.applications.each do |app|
            write_application(site, app)
          end
          site.applications.removed.each do |app|
            remove_application(site, app)
          end
        end
        repository.sites.removed.each do |site|
          remove_site(site)
        end
      end

      # Reads a repository to disk. Returns an instance of Shak::Repository
      def read
      end

      private

      def path_to(filename)
        File.join(Shak.config.data_dir, filename)
      end

      def site_dir(site)
        path_to(site.hostname)
      end

      def site_conf(site)
        path_to(site.hostname + '.yaml')
      end

      def app_conf(site, app)
        File.join(site_dir(site), app.id + '.yaml')
      end

      def write_site(site)
        File.open(site_conf(site), 'w') do |f|
          Shak::Context::SerializeSite.new(site).serialize(f)
        end
      end

      def write_application(site, app)
        dir = site_dir(site)
        FileUtils.mkdir_p(dir)
        app_file = app_conf(site, app)
        File.open(app_file, 'w') do |f|
          Shak::Context::SerializeApplication.new(app).serialize(f)
        end
      end

      def remove_site(site)
        FileUtils.rm_rf(site_dir(site))
        FileUtils.rm_f(site_conf(site))
      end

      def remove_application(site, app)
        FileUtils.rm_f(app_conf(site, app))
      end

    end
  end
end
