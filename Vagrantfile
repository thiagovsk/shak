# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = ENV.fetch('BOX', "debian/stretch64")
  config.vm.network "forwarded_port", guest: 80, host: 8080 # web server
  config.vm.network "forwarded_port", guest: 443, host: 8443 # web server (SSL)
  config.vm.network "forwarded_port", guest: 3000, host: 3000 # shak web UI
  config.vm.provision :shell do |shell|
    shell.privileged = false
    shell.path = 'utils/bootstrap'
    shell.args = ['DEBFULLNAME', 'DEBEMAIL'].map do |var|
      ENV[var] && "#{var}='#{ENV[var]}'" || nil
    end.compact
    shell.keep_color = true
  end
end
