require 'tempfile'
require 'json'


require 'shak/context/base'

module Shak
  module Context
    class ApplyConfiguration < Base

      def apply!
        solo_config = generate_solo_configuration
        json_attributes = generate_json_attributes_file
        system(
          'sudo', 'chef-solo',
          '--json-attributes', json_attributes,
          '--config', solo_config
        )
      end

      protected

      def generate_solo_configuration
        f = Tempfile.new('shak.rb')
        f.puts("cookbook_path '#{Shak.config.cookbooks_dir}'")
        f.puts('ssl_verify_mode :verify_peer')
        f.close
        f.path
      end

      def generate_json_attributes_file
        f = Tempfile.new('shak.json')

        sites = repository.sites.all

        data = {
          "run_list" => repository.run_list,
          "sites" => sites.map do |s|
            site_data(s)
          end,
          'applications' => sites.map do |s|
            s.applications.all.map do |a|
              {
                "site" => site_data(s),
              }.merge(app_data(a))
            end
          end.flatten,
        }

        f.write(JSON.pretty_generate(data))
        f.close
        f.path
      end

      def site_data(s)
        {
          "hostname" => s.hostname,
          # FIXME other attributes
        }
      end

      def app_data(a)
        {
          "cookbook_name" => a.cookbook_name,
          "path" => a.path,
          "id" => a.filename_id,
          # FIXME other attributes
        }
      end

    end
  end
end
