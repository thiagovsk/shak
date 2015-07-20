package 'dovecot-imapd'
service 'dovecot'

key_path = "/etc/ssl/private/#{node['fqdn']}.key"
crt_path = "/etc/ssl/certs/#{node['fqdn']}.pem"

import_ssl("/etc/dovecot/dovecot.pem", crt_path)
import_ssl("/etc/dovecot/private/dovecot.pem", key_path)

email_cookbook_file('/etc/dovecot/conf.d/10-mail.conf')
email_cookbook_file('/etc/dovecot/conf.d/10-ssl.conf')
email_cookbook_file('/etc/dovecot/conf.d/11-postfix-auth.conf')
email_cookbook_file('/etc/dovecot/conf.d/20-imap.conf')
email_cookbook_file('/etc/dovecot/conf.d/20-disable-imap-non-ssl.conf')
