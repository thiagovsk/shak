require 'shak/context/add_app'

command :'add-app' do |c|
  c.syntax = 'shak add-app [OPTIONS] HOSTNAME APP PATH [KEY=VALUE ...]'
  c.description = 'Adds a new app to an existing site'
  c.action do |args,options|
    hostname = args.shift
    appname = args.shift
    path = args.shift

    if [hostname, appname, path].any?(&:nil?)
      fail('usage: ' + c.syntax)
    end

    extra_data = parse_extra_data(args)

    add_app = Shak::Context::AddApp.new
    add_app.add!(hostname, appname, path, extra_data)

  end
end
