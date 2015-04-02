package 'nginx'
service 'nginx' do
  supports :reload => true, :restart => true
end

node['sites'].each do |s|
  site s['hostname']
end
