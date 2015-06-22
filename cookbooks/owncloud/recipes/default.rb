include_recipe "shak::php5_nginx"

package 'postgresql'
package 'owncloud'
package 'php5-pgsql'

each_instance_of("owncloud") do |app|

  config_dir = "/etc/owncloud/#{app['instance_id']}"

  directory "#{app['instance_id']}: crete data directory" do
    recursive true
    path "/var/lib/owncloud/data_#{app['instance_id']}"
    group 'www-data'
    owner 'www-data'
  end

  directory "#{app['instance_id']}: create config directory" do
    recursive true
    path "/etc/owncloud/#{app['instance_id']}"
    group 'www-data'
    owner 'www-data'
    mode '0777'
  end

  template "#{app['instance_id']}: create autoconfig.php in #{config_dir}" do
    group 'www-data'
    owner 'www-data'
    path "#{config_dir}/autoconfig.php"
    source "autoconfig.php.erb"
    variables :app => app
  end

  #FIXME remove this, when upgrade owncloud package with multi-instance support
  template "#{app['instance_id']}: create autoconfig.php in /etc/owncloud" do
    group 'www-data'
    owner 'www-data'
    path "/etc/owncloud/autoconfig.php"
    source "autoconfig.php.erb"
    variables :app => app
  end

  template "#{app['instance_id']}: create database_#{app['instance_id']}.sql" do
    path "#{config_dir}/database_#{app['instance_id']}.sql"
    source "postgres-conf.sql.erb"
    variables :app => app
  end

  execute "#{app['instance_id']}: create database" do
    user 'postgres'
    command "psql -a -f #{config_dir}/database_#{app['instance_id']}.sql"
    not_if "sudo -u postgres psql -d #{app['instance_id']} "
  end

end
