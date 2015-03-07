module Shak

  class Site

    attr_accessor :hostname
    attr_accessor :name
    attr_accessor :ssl
    attr_accessor :www

    def initialize(attributes=nil)
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end if attributes
    end

    def applications
      @applications ||= []
    end

  end

end
