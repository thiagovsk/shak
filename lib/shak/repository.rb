require 'forwardable'

module Shak

  # A +Repository+ manages access to the sites hosted at a given server.
  class Repository

    extend Forwardable
    delegate [:each, :map] => :all

    attr_accessor :timestamp

    def run_list
      preamble_recipes + user_recipes + postamble_recipes
    end

    def ==(other)
      self.backend == other.backend
    end

    def add(app)
      app.id ||= next_id(app.name)
      if backend[app.id]
        raise ArgumentError.new("Duplicated ID `#{app.id}`")
      end
      if app.id.size > 16
        raise ArgumentError.new("ID `#{app.id}` is too large (max: 16 characters)")
      end
      backend[app.id] = app
    end

    def all
      backend.values
    end

    def count
      backend.size
    end

    def find(id)
      backend[id] || (raise ArgumentError.new("No application found with ID `#{id}`"))
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
      apps = backend.values.select { |app| app.id =~ /^#{name}_(\d+)/ }
      if apps.size == 0
        "#{name}_1"
      else
        last = apps.map { |app| app.id.split('_').last.to_i }.sort.last
        "#{name}_#{last + 1}"
      end
    end

    def backend
      @backend ||= {}
    end

    def preamble_recipes
      ['recipe[shak::preconfig]']
    end

    def user_recipes
      map { |app| "recipe[#{app.name}]" }.uniq
    end

    def postamble_recipes
      ['recipe[shak]']
    end

  end

end
