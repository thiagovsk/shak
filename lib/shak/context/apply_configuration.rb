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
        data = {
          "run_list" => repository.run_list,
          "sites" => repository.sites.all.map do |s|
            {
              "hostname" => s.hostname,
              # FIXME other attributes
            }
          end,
        }
        f.write(JSON.pretty_generate(data))
        f.close
        f.path
      end

    end
  end
end
