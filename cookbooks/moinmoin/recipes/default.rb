package 'python-moinmoin'
package 'uwsgi'
package 'uwsgi-plugin-python'

each_instance_of('moinmoin') do |app|
  #TODO verificar as pastas p/ multiplas instancias de wiki

  template "#{app['id']}: create uwsgi.ini" do
    group 'www-data'
    owner 'www-data'
    path '/usr/share/moin/config/uwsgi.ini'
    source 'uwsgi.ini.erb'
    variables :app => app
  end

end
