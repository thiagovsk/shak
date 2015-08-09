command :web do |c|
  c.syntax = 'shak web [OPTIONS]'
  c.description = 'runs shak web-based frontend'

  c.option '-p PORT', '--port PORT', Integer, 'Port number'

  c.action do |args,options|
    if args.size != 0
      fail_usage c
    end

    options.default port: 9999

    config_ru = File.expand_path('../../web/config.ru', __FILE__)
    exec 'rackup', '--port', options.port.to_s, config_ru
  end
end
