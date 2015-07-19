require 'forwardable'

module Shak

  # A +Repository+ manages access to the sites hosted at a given server.
  class Repository

    extend Forwardable
    delegate [:each, :map] => :all

    def run_list
      map { |app| "recipe[#{app.name}]" }.flatten + ['recipe[shak]']
    end

    def ==(other)
      self.backend == other.backend
    end

    def add(item)
      raise ArgumentError.new("An ID is mandatory!") unless item.id
      backend[item.id] = item
    end

    def all
      backend.values
    end

    def count
      backend.size
    end

    def find(id)
      backend[id]
    end

    def remove(app_id)
      backend.delete(app_id)
      removed << app_id
    end

    def removed
      @removed ||= []
    end

    protected

    def backend
      @backend ||= {}
    end

  end

end
