module Shak
  class SetWithMemory

    extend Forwardable
    delegate :each => :all

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

    def ==(other)
      backend == other.send(:backend)
    end

    private

    def backend
      @backend ||= {}
    end
  end
end
