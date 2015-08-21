class Chef::Resource::Template
  def html_generated_by_us(file)
    ::File.readlines(file).map(&:strip).any? do |line|
      line == '<meta name="generator" value="shak"/>'
    end
  end
end

package 'rsync'

each_instance_of('static_site') do |app|

  app['directory'] = ::File.join('/srv', web_app_id(app))

  directory app['directory'] do
    recursive true
  end

  execute 'chown on ' + app['directory'] do
    command "chown -R #{app['user']}:#{app['group']} #{app['directory']}"
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
