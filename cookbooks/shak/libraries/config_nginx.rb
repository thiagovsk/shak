class Chef
  class Recipe

    def nginx_config_files
      @@nginx_config_files ||= []
    end

    def nginx_config_site(site)
      hostname = site['hostname']
      config = "/var/lib/shak/etc/nginx/#{hostname}.conf"
      nginx_config_files << config
      template config do
        source    'site.conf.erb'
        variables :hostname => hostname
        notifies  :reload, 'service[nginx]'
      end
      directory "/var/lib/shak/etc/nginx/#{hostname}"
    end

    def nginx_config_app(app)
      hostname = app['site']['hostname']
      id = app['id']
      config = "/var/lib/shak/etc/nginx/#{hostname}/#{id}.conf"
      nginx_config_files << config
      template config do
        source    "nginx.conf.erb"
        cookbook  app['cookbook_name']
        notifies  :reload, 'service[nginx]'
        variables :app => app
      end
    end

    def nginx_cleanup
      installed = Dir.glob('/var/lib/shak/etc/nginx/**/*.conf')
      to_remove = installed - nginx_config_files
      to_remove.each do |f|
        file f do
          action :delete
          notifies :reload, 'service[nginx]'
        end
      end
    end

  end
end
