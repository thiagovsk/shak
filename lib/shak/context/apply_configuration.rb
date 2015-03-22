require 'tempfile'
require 'json'

require 'shak'
require 'shak/repository_disk_store'

module Shak
  module Context
    class ApplyConfiguration

      def store
        @store ||= Shak::RepositoryDiskStore.new
      end

      def repository
        @repository ||= store.read
      end

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
        f.write(JSON.pretty_generate({ "run_list" => repository.run_list}))
        f.close
        f.path
      end

    end
  end
end
