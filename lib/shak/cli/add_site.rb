require 'shak/repository'
require 'shak/context/add_site'

command :'add-site' do |c|
  c.syntax = 'shak add-site [OPTIONS] NAME [KEY=VALUE ...]'
  c.description = 'Adds a new site to the system'
  c.action do |args,options|
    if args.empty?
      fail 'usage: ' + c.syntax
    end

    hostname = args.shift
    data = parse_extra_data(args)

    add_site = Shak::Context::AddSite.new

    add_site.add!(hostname, data)

  end
end
