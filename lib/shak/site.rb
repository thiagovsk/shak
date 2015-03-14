require 'forwardable'

require 'shak/set_with_memory'

module Shak

  class Site

    attr_accessor :hostname
    attr_accessor :name
    attr_accessor :ssl
    attr_accessor :www

    alias :id :hostname

    def initialize(attributes=nil)
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end if attributes
    end

    def applications
      @applications ||= Shak::SetWithMemory.new
    end

    def ==(other)
      [:hostname, :name, :ssl, :www, :applications].all? do |attr|
        self.send(attr) == other.send(attr)
      end
    end

  end

end
