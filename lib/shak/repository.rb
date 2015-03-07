require 'shak'

module Shak

  # A +Repository+ manages access to the sites hosted at a given server.
  class Repository

    def initialize
      @sites = {}
    end

    def all
      @sites.keys
    end

    def count
      @sites.size
    end

    def find(hostname)
      @sites[hostname]
    end

    def add(site)
      raise ValueError("Hostname is mandatory!") unless site.hostname
      @sites[site.hostname] = site
    end

    def update(hostname, site)
      @sites[hostname] = site
    end

    def remove(hostname)
      @sites.delete(hostname)
    end

    class << self

      # Reads from the on-disk storage and returns a new instance of
      # +Repository+.
      def read
      end

    end

    # Writes to the on-disk storage
    def write
    end

  end

end
