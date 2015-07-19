require 'tempfile'
require 'json'

require 'shak'
require 'shak/operation/base'

module Shak
  module Operation
    class ApplyConfiguration < Base

      def perform
        solo_config = generate_solo_configuration
        json_attributes = generate_json_attributes_file
        Shak.run(
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
          'applications' => repository.all.map do |a|
            app_data(a)
          end
        }

        f.write(JSON.pretty_generate(data))
        f.close
        f.path
      end

      def app_data(a)
        {
          "name" => a.name,
          "cookbook_name" => a.name,
          "id" => a.id,
        }.merge(a.input_data)
      end

    end
  end
end
