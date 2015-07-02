require 'uuidtools'

require 'shak/cookbook'

module Shak

  class Application

    attr_accessor :name
    attr_accessor :id

    def initialize(name=nil, id=nil)
      @name = name
      @id = id || UUIDTools::UUID.random_create.to_s
    end

    def instance_id
      id.gsub('-', '_')
    end

    def cookbook
      @cookbook ||= Shak::Cookbook[name]
    end

    def input
      @input ||= cookbook.input
    end

    def input_data
      input.fields.inject({}) do |data,field|
        data[field.name.to_s] = field.value
        data
      end
    end

    def input_data=(data)
      data.each do |field,value|
        send("#{field}=", value)
      end
    end

    # Delegates self.$attribute and self.$attribute= to input object.
    def method_missing(method, *args)
      field_name = method.to_s.gsub(/=$/, '').to_sym
      if input.has_field?(field_name)
        if method == field_name
          input[method]
        else
          input[field_name] = args.first
        end
      else
        super
      end
    end

    def ==(other)
      [ :name, :id, :input ].all? { |attr| self.send(attr) == other.send(attr) }
    end

  end

end
