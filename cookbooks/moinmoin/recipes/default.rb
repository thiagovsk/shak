include_recipe "shak::default"

package 'uwsgi'
package 'uwsgi-plugin-python'
package 'python-moinmoin'

each_instance_of('moinmoin') do |app|
  #TODO verificar as pastas p/ multiplas instancias de wiki
  # começar a fazer funcionar pra uma wiki só
  default_directory = "/usr/share/moin"
  wiki_directory = "/var/lib/moin"

  directory "#{app['id']}: crete wiki directory" do
    recursive true
    path wiki_directory
    group 'www-data'
    owner 'www-data'
  end

  execute "#{app['id']}: copy data folders to wiki directory" do
    command "cp -r #{default_directory}/data  #{wiki_directory}"
    not_if "test -d #{wiki_directory}/data"
  end

  execute "#{app['id']}: copy underlay folders to wiki directory" do
    command "cp -r #{default_directory}/underlay  #{wiki_directory}"
    not_if "test -d #{wiki_directory}/underlay"
  end

  execute "#{app['id']} change permission in /var/lib/moin" do
    command "chown -R www-data: #{wiki_directory}"
  end

  template "#{app['id']}: create mywiki.py" do
    path "/etc/moin/mywiki.py"
    source "mywiki.py.erb"
    variables :wiki_directory => wiki_directory
  end

  template "#{app['id']}: create moin.wsgi" do
    path "/usr/share/moin/moin.wsgi"
    source "moin.wsgi.erb"
  end

  template "#{app['id']}: create uwsgi.ini" do
    path "/etc/uwsgi/apps-available/uwsgi.ini"
    source "uwsgi.ini.erb"
  end

  link '/etc/uwsgi/apps-enabled/uwsgi.ini' do
    to '/etc/uwsgi/apps-available/uwsgi.ini'
  end

  service "uwsgi" do
    action :reload
  end

end
