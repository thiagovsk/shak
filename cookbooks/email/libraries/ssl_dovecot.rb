class Chef
  class Recipe

    def import_ssl(source_path, destination_path)
      file "Copy self assigned ssl to dovecot folder" do
        owner 'root'
        group 'root'
        user  'root'
        path  source_path
        action  :create
        content lazy { ::File.open(destination_path).read }
        notifies  :restart, 'service[dovecot]'
      end
    end

    def email_cookbook_file(file)
      cookbook_file file do
        user  'root'
        group 'root'
        mode  '0644'
        notifies  :restart, 'service[dovecot]'
      end
    end

  end
end
