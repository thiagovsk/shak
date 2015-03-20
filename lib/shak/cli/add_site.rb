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

    data = args.inject({}) do |acc,arg|
      key, value = arg.split('=')
      acc[key] = value
      acc
    end

    add_site = Shak::Context::AddSite.new

    add_site.add!(hostname, data)

  end
end
