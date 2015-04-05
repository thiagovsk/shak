class Chef::Resource::Template
  def html_generated_by_us(file)
    ::File.readlines(file).map(&:strip).any? do |line|
      line == '<meta name="generator" value="shak"/>'
    end
  end
end

each_instance_of('static_site') do |app|

  basedir = '/var/lib/shak/data/static_site'
  app['directory'] = ::File.join(basedir, app['site']['hostname'], app['id'])

  directory app['directory'] do
    recursive true
  end

  index = File.join(app['directory'], 'index.html')

  # TODO skip if using an archive
  template index do
    only_if do
      !File.exists?(index) || html_generated_by_us(index)
    end
    source "index.#{app['site_type']}.html.erb"
    variables :app => app
  end

  # TODO uncompress archive if using one

end
