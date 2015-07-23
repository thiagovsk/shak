package "openssl"

group "ssl-cert" do
  members "root"
end

web_applications.each do |app|
  self_signed_certificate(app['hostname'])
end

self_signed_certificate(node['fqdn'])
