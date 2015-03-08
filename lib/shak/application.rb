module Shak

  class Application

    attr_accessor :path
    attr_accessor :site

    attr_accessor :name
    attr_accessor :cookbook_name

    def initialize(data=nil)
      data.each do |k,v|
        self.send("#{k}=", v)
      end if data
      @path ||= '/'
    end

    def id
      path.gsub('/', '_')
    end

    # TODO store attributes declared in the cookbook

  end

end
