class Chef
  class Recipe

    def web_sites
      web_applications.map { |app| app['hostname']}.uniq
    end

    def web_applications
      applications.select { |app| app.has_key?('hostname') && app.has_key?('path') }
    end

    def applications
      # using a class variable to share across different recipes (which are
      # different objects)
      @@applications ||= node['applications'].to_a
    end

    def each_instance_of(appname)
      applications.each do |app|
        if app['name'] == appname
          yield app
        end
      end
    end
  end
end
