include_recipe "shak::php5_nginx"

package 'postgresql'
package 'owncloud'
package 'php5-pgsql'

each_instance_of("owncloud") do |app|

  config_dir = "/etc/owncloud/#{app['id']}"

  directory "#{app['id']}: crete data directory" do
    recursive true
    path "/var/lib/owncloud/data_#{app['id']}"
    group 'www-data'
    owner 'www-data'
  end

  directory "#{app['id']}: create config directory" do
    recursive true
    path "/etc/owncloud/#{app['id']}"
    group 'www-data'
    owner 'www-data'
    mode '0777'
  end

  template "#{app['id']}: create autoconfig.php in #{config_dir}" do
    group 'www-data'
    owner 'www-data'
    path "#{config_dir}/autoconfig.php"
    source "autoconfig.php.erb"
    variables :app => app
  end

  #FIXME remove this, when upgrade owncloud package with multi-instance support
  template "#{app['id']}: create autoconfig.php in /etc/owncloud" do
    group 'www-data'
    owner 'www-data'
    path "/etc/owncloud/autoconfig.php"
    source "autoconfig.php.erb"
    variables :app => app
  end

  template "#{app['id']}: create database_#{app['id']}.sql" do
    path "#{config_dir}/database_#{app['id']}.sql"
    source "postgres-conf.sql.erb"
    variables :app => app
  end

  execute "#{app['id']}: create database" do
    user 'postgres'
    command "psql -a -f #{config_dir}/database_#{app['id']}.sql"
    not_if "sudo -u postgres psql -d #{app['id']} "
  end

end
