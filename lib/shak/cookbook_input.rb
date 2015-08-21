module Shak

  class CookbookInput

    def fields
      @fields ||= []
    end

    def [](name)
      __field_map__.fetch(name).value
    end

    def []=(name, value)
      __field_map__.fetch(name).value = value
    end

    def has_field?(name)
      __field_map__.has_key?(name)
    end

    def text(name, &block)
      __add_field__(name, Shak::CookbookInput::TextField, &block)
    end

    def select(name, &block)
      __add_field__(name, Shak::CookbookInput::SelectField, &block)
    end

    def blob(name, &block)
      __add_field__(name, Shak::CookbookInput::BlobField, &block)
    end

    def boolean(name, &block)
      __add_field__(name, Shak::CookbookInput::BooleanField, &block)
    end

    def unique(*fields)
      unique_keys << fields
    end

    def unique_keys
      @unique_keys ||= []
    end

    def valid?
      fields.all?(&:valid?)
    end

    def errors
      fields.map(&:errors).flatten
    end

    def check_semantics!
      fields.each(&:check_semantics!)
    end

    def ==(other)
      fields == other.fields
    end

    def label_format(format=nil)
      @label_format = format if format
      @label_format
    end

    private

    def __add_field__(name, type, &block)
      f = type.new(name, self)
      f.instance_eval(&block) if block
      fields << f
      __field_map__[name] = f
    end

    def __field_map__
      @__field_map__ ||= {}
    end

  end

end

# TODO move these to their own files
module Shak

  class CookbookInput

    Error = Struct.new(:name, :value, :message)

    class Field

      attr_reader :name
      attr_reader :value
      attr_accessor :field_set

      def initialize(name, field_set=nil)
        @name = name
        @field_set = field_set
        @title = name.to_s.capitalize
        @mandatory = false
      end

      def value=(v)
        @value = v
      end

      def title(v=nil)
        @title = v if v
        @title
      end

      def default(v=nil)
        if v
          @default = v
          self.value ||= v
        end
        @default
      end

      attr_accessor :depends_on
      attr_accessor :depends_on_value

      def dependent_on(field, value)
        @depends_on = field
        @depends_on_value = value
      end

      def mandatory?
        @mandatory
      end

      def mandatory
        @mandatory = true
      end

      def valid?
        errors.clear
        validate
        errors.empty?
      end

      def errors
        @errors ||= []
      end

      def validate
        return if ignored?
        if mandatory? && (value.nil? || value.empty?)
          errors << Error.new(name, value, "%s is mandatory" % title)
        end
      end

      class InvalidSemantics < Exception; end

      def check_semantics!
        if depends_on && !field_set.has_field?(depends_on)
          raise InvalidSemantics.new(
            '%s depends on unexisting field %s' % [title, depends_on]
          )
        end
      end

      def ignored?
        if depends_on
          field_set[depends_on] != depends_on_value
        else
          false
        end
      end

      def ==(other)
        name == other.name && value == other.value
      end

    end

    class TextField < Field; end

    class SelectField < Field

      Option = Struct.new(:value, :name)

      def value=(v)
        super(v.to_sym)
      end

      def option(value, name)
        options << Option.new(value, name)
      end

      def options
        @options ||= []
      end

      def validate
        super
        if (self.value && !options.any? { |opt| opt.value == self.value })
          errors << '"%s" is not a valid value for %s' % [self.value, title]
        end
      end

      def check_semantics!
        if options.empty?
          raise InvalidSemantics.new('Select field %s has not options!' % title)
        end
      end

    end

    class BlobField < Field; end # TODO
    class BooleanField < Field; end # TODO

  end

end
