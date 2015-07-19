class Chef::Resource::Template
  def html_generated_by_us(file)
    ::File.readlines(file).map(&:strip).any? do |line|
      line == '<meta name="generator" value="shak"/>'
    end
  end
end

each_instance_of('static_site') do |app|

  app['directory'] = ::File.join('/srv', web_app_id(app))

  directory app['directory'] do
    recursive true
    owner app['user']
  end

  index = File.join(app['directory'], 'index.html')

  template index do
    only_if do
      !File.exists?(index) || html_generated_by_us(index)
    end
    source "index.html.erb"
    variables :app => app
    owner app['user']
  end

end
