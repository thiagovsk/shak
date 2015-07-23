package 'postfix'
package 'bsd-mailx'
service 'postfix'

domains = ""
each_instance_of("email") do |app|
  domains << ", #{app['hostname']}"
end

template '/etc/postfix/main.cf' do
  user  'root'
  group 'root'
  mode  '0644'
  source  'master_main.cf.erb'
  variables :domains => domains
  notifies  :restart, 'service[postfix]'
end

cookbook_file '/etc/postfix/master.cf' do
  user  'root'
  group 'root'
  mode  '0644'
  notifies  :restart, 'service[postfix]'
end
