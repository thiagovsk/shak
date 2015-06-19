package 'php5-fpm'
package 'nginx'

service 'php5-fpm' do
  action [:enable]
end
