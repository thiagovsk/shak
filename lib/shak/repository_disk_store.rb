require 'fileutils'

require 'shak'
require 'shak/repository'
require 'shak/application_serializer'

module Shak
  class RepositoryDiskStore

    # Writes +repository+ to disk.
    def write(repository)
      FileUtils.mkdir_p(Shak.config.repository_dir)
      repository.each do |app|
        serializer = Shak::ApplicationSerializer.new
        file = application_file(app)
        skip = false

        if File.exist?(file)
          data = serializer.read(File.read(file)).input_data
          if data == app.input_data
            # data on-disk is the same, no need to write again
            skip = true
          end
        end

        unless skip
          File.open(file, 'w') do |f|
            serializer.serialize(app, f)
          end
        end
      end
      repository.removed.each do |app|
        FileUtils.rm_f(application_file(app))
      end
    end

    # Reads a repository from disk. Returns an instance of Shak::Repository
    def read
      repository = Shak::Repository.new
      if !Dir.exist?(Shak.config.repository_dir)
        return repository
      end

      app_reader = Shak::ApplicationSerializer.new

      Dir.glob(File.join(Shak.config.repository_dir, '*.yaml')).each do |data|
        app = File.open(data) do |f|
          app_reader.read(f)
        end
        app.timestamp = File.stat(data).mtime
        repository.add(app)
      end

      if File.exist?(deploy_timestamp_file)
        repository.timestamp = File.stat(deploy_timestamp_file).mtime
      end

      repository
    end

    def add_deploy_timestamp
      FileUtils.mkdir_p(Shak.config.repository_dir)
      FileUtils.touch(deploy_timestamp_file)
    end

    def deploy_timestamp_file
      File.join(Shak.config.repository_dir, 'deployment.stamp')
    end

    private

    def application_file(app)
      File.join(Shak.config.repository_dir, "#{app.id}.yaml")
    end

  end
end
