require 'text-table'

require 'shak/repository_disk_store'

command :show do |c|
  c.syntax = 'shak show [OPTIONS]'
  c.syntax = 'Shows installed sites and applications'
  c.action do |args, options|
    fail_usage(c) if args.size > 0

    store = RepositoryDiskStore.new
    repository = store.read

    table = Text::Table.new
    table.head = ['Site', 'Application', 'Path']
    repository.each do |site|
      site.each do |app|
        table.rows << [site.hostname, app.cookbook_name, app.path]
      end
    end
    puts table
  end
end
