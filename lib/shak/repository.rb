require 'forwardable'

require 'shak/set_with_memory'

module Shak

  # A +Repository+ manages access to the sites hosted at a given server.
  class Repository

    extend Forwardable
    delegate [:all, :each, :find, :add, :remove, :count, :removed] => :applications

    def run_list
      (applications.all.map { |app| "recipe[#{app.name}]" }).flatten + ['recipe[shak]']
    end

    def ==(other)
      self.applications == other.applications if defined? other.applications
    end

    protected

    def applications
      @applications ||= Shak::SetWithMemory.new
    end

  end

end
