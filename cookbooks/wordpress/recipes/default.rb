include_recipe "shak::php5_nginx"

package 'wordpress'
package 'mysql-server'

each_instance_of("wordpress") do |app|

  basedir = "/var/lib/wordpress"
  destination_dir = "#{basedir}/#{app['id']}"

  template "#{app['id']}: create config.php" do
    path "/etc/wordpress/config-#{app['site']['hostname']}.php"
    source "config.php.erb"
    variables :app => app
  end

  directory "#{app['id']}: create #{destination_dir}" do
    path destination_dir
    recursive true
  end

  execute "#{app['id']}: copy wp-content to #{destination_dir}" do
    command "sudo cp #{basedir}/wp-content/ #{destination_dir} -rf"
    not_if "test -d #{destination_dir}"
  end

  template "#{app['id']}: create database.sql" do
    path "#{destination_dir}/database.sql"
    source "mysql-conf.sql.erb"
    variables :app => app
  end

  execute "#{app['id']}: configure database" do
   command "cat #{destination_dir}/database.sql | mysql --defaults-extra-file=/etc/mysql/debian.cnf"
   not_if "mysql -u root -e 'use #{app['id']}'"
  end

end
