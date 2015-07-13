package 'nginx'
service 'nginx' do
  supports :reload => true, :restart => true
end

directory '/var/lib/shak/etc/nginx' do
  recursive true
end
file '/etc/nginx/conf.d/shak.conf' do
  content "include /var/lib/shak/etc/nginx/*.conf;\n"
  notifies :reload, 'service[nginx]'
end

web_sites.each do |site|
  nginx_config_site site
end

web_applications.each do |app|
  nginx_config_app(app)
end

nginx_cleanup
