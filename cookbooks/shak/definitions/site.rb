define :site do
  hostname = params[:name]
  template "/etc/nginx/conf.d/#{hostname}.conf" do
    source    'site.conf.erb'
    variables :hostname => hostname
    notifies  :reload, 'service[nginx]'
  end
end
