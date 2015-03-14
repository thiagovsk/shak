module Shak

  class Application

    attr_accessor :path
    attr_accessor :site

    attr_accessor :name
    attr_accessor :cookbook_name
    attr_accessor :cookbook_data

    def initialize(data=nil)
      data.each do |k,v|
        self.send("#{k}=", v)
      end if data
      @path ||= '/'
      @cookbook_data ||= {}
    end

    def id
      path.gsub('/', '_')
    end

    def ==(other)
      [ :name, :cookbook_name, :path, :cookbook_data, ].all? { |attr| self.send(attr) == other.send(attr) }
    end

  end

end
