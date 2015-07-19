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

    def add(app)
      app.id ||= next_id(app.name)
      backend[app.id] = app
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

    def next_id(name)
      n = backend.values.select { |app| app.name == name }.size
      "#{name}_#{n + 1}"
    end

    def backend
      @backend ||= {}
    end

  end

end
