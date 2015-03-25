require 'text-table'

require 'shak/context/traverse'

command :show do |c|
  c.syntax = 'shak show [OPTIONS]'
  c.syntax = 'Shows installed sites and applications'
  c.action do |args, options|
    fail_usage(c) if args.size > 0

    traversal = Shak::Context::Traverse.new

    table = Text::Table.new
    table.head = ['Site', 'Application', 'Path']
    traversal.each_app do |app|
      table.rows << [app.site.hostname, app.cookbook_name, app.path]
    end

    if table.rows.size > 0
      pager.puts table
    end
  end
end
