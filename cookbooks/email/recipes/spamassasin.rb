package 'spamassassin'
package 'spamc'

service 'spamassassin' do
  action  :start
end

spamd_home = '/var/log/spamd'

directory "Create spamassasin home directory" do
  path  spamd_home
end

user 'spamd' do
  home  spamd_home
  shell '/bin/bash'
end

cookbook_file 'Spamassasin default configuration' do
  source  'spamassasin'
  path  '/etc/default/spamassasin'
  user  'spamd'
  mode  '0644'
end

cookbook_file 'Spamassasin local configuration' do
  source 'local.cf'
  path  '/etc/spamassassin/local.cf'
  user  'spamd'
  mode  '0644'
  notifies  :restart, 'service[spamassassin]'
  notifies  :restart, 'service[postfix]'
end
