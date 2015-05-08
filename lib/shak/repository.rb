require 'forwardable'

require 'shak/set_with_memory'

module Shak

  # A +Repository+ manages access to the sites hosted at a given server.
  class Repository

    extend Forwardable
    delegate [:each, :find] => :sites

    def sites
      @sites ||= Shak::SetWithMemory.new
    end

    def run_list
      (sites.all.map { |s| s.run_list }).flatten + ['recipe[shak]']
    end

    def ==(other)
      self.sites == other.sites if defined? other.sites
    end

  end

end
