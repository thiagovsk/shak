require  'text-table'

require 'shak/operation/list'

command :list do |c|
  c.syntax = 'shak list'
  c.description = 'lists installed applications'
  c.action do |args,options|
    fail_usage(c) if args.size != 0

    table = Text::Table.new
    table.head = ['Application', 'Id', 'Link', 'Status']

    list = Shak::Operation::List.new do |app|
      table.rows << [app[:name], app[:id], app[:link], app[:status]]
    end
    list.perform

    if table.rows.size > 0
      pager.puts table
    end

  end

end
