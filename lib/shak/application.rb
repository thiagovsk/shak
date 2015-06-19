require 'shak/cookbook'

module Shak

  class Application

    attr_accessor :path
    attr_accessor :name
    attr_accessor :cookbook_name
    attr_accessor :site

    def initialize(data=nil)
      data.each do |k,v|
        self.send("#{k}=", v)
      end if data
      @path ||= '/'
    end

    def cookbook
      @cookbook ||= Shak::Cookbook[cookbook_name]
    end

    def cookbook=(cookbook)
      @cookbook_name = cookbook.name
      @cookbook = cookbook
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

    alias :id :path

    def filename_id
      path.gsub('/', '_')
    end

    def instance_id
      instance_name  = site.hostname.gsub('.', '_')
      if path == '/' || path == ''
        instance_name
      else
        instance_name + '_at' + path.gsub('/','_')
      end
    end

    def ==(other)
      [ :name, :cookbook_name, :path, :input ].all? { |attr| self.send(attr) == other.send(attr) }
    end

  end

end
