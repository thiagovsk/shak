require 'forwardable'

require 'shak/set_with_memory'

module Shak

  # A +Repository+ manages access to the sites hosted at a given server.
  class Repository

    extend Forwardable
    delegate :each => :sites
    include Enumerable

    def sites
      @sites ||= Shak::SetWithMemory.new
    end

    def ==(other)
      self.sites == other.sites
    end

  end

end
