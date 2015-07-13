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
        File.open(application_file(app), 'w') do |f|
          Shak::ApplicationSerializer.new.serialize(app, f)
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
        repository.add(app)
      end
      repository
    end

    private

    def application_file(app)
      File.join(Shak.config.repository_dir, "#{app.name}_#{app.id}.yaml")
    end

  end
end
