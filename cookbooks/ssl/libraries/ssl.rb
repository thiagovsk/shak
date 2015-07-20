class Chef
  class Recipe

    def generate_ssl_conf(hostname)
      template "#{hostname} Generate openssl.cnf" do
        path "/etc/ssl/#{hostname}_openssl.cnf"
        source "openssl.cnf.erb"
        variables :hostname => hostname
      end
    end

    def create_ssl(hostname)
      key_path = "/etc/ssl/private/#{hostname}.key"
      crt_path = "/etc/ssl/certs/#{hostname}.pem"
      ssl_config_path = "/etc/ssl/#{hostname}_openssl.cnf"

      execute "#{hostname} Generate certificate signing request" do
        command "openssl req -x509 -newkey rsa:2048 -keyout #{key_path}"\
        " -out #{crt_path} -nodes -config #{ssl_config_path} -batch"
        not_if "test -f #{crt_path} && test -f #{key_path}"
      end
    end

    def ssl_permission(hostname)
      file "/etc/ssl/private/#{hostname}.key" do
        owner 'root'
        group 'ssl-cert'
        mode '0640'
        action :create
      end
      file "/etc/ssl/certs/#{hostname}.pem" do
        owner 'root'
        group 'ssl-cert'
        mode '0640'
        action :create
      end
    end

    def self_signed_certificate(hostname)
      generate_ssl_conf(hostname)
      create_ssl(hostname)
      ssl_permission(hostname)
    end

  end
end
