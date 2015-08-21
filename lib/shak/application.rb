require 'shak/cookbook'

module Shak

  class Application

    class InvalidInput < ArgumentError
      attr_reader :errors
      def initialize(errors)
        @errors = errors
        super('Invalid input')
      end
    end

    attr_accessor :name
    attr_accessor :id

    def initialize(name, id=nil)
      @name = name
      @id = id
    end

    def cookbook
      @cookbook ||= Shak::Cookbook[name]
    end

    def input
      @input ||= cookbook.input
    end

    def validate_input!
      unless input.valid?
        raise InvalidInput.new(input.errors)
      end
    end

    def valid?
      input.valid?
    end

    def errors
      input.errors
    end

    def has_key?(k)
      input_data.has_key?(k.to_s)
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

    def label
      label_format % input_data.map { |k,v| { k.to_sym => v } }.reduce(&:merge)
    end

    def label_format
      input.label_format || name
    end

    def ==(other)
      [ :name, :id, :input ].all? { |attr| self.send(attr) == other.send(attr) }
    end

    def inspect
      "#{id}(#{name})"
    end

  end

end
