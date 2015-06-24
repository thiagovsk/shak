require 'shak/operation/add_site'

command :'add-site' do |c|
  c.syntax = 'shak add-site [OPTIONS] NAME [KEY=VALUE ...]'
  c.description = 'Adds a new site to the system'
  c.action do |args,options|
    if args.empty?
      fail_usage c
    end

    hostname = args.shift
    data = parse_extra_data(args)

    add_site = Shak::Operation::AddSite.new

    add_site.add!(hostname, data)

  end
end
