class Chef
  class Recipe

    def sites
      # using a class variable to share across different recipes (which are
      # different objects)
      @@sites ||= node['sites'].to_a
    end

    def applications
      # using a class variable to share across different recipes (which are
      # different objects)
      @@applications ||= node['applications'].to_a
    end

    def each_instance_of(appname)
      applications.each do |app|
        if app['cookbook_name'] == appname
          yield app
        end
      end
    end
  end
end
