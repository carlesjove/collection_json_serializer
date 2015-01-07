module CollectionJson
  class Serializer
    class << self
      attr_accessor :href
      attr_accessor :template
      attr_accessor :links
      attr_accessor :queries
      attr_accessor :_items
    end

    def self.inherited(base)
      base.href = []
      base.template = []
      base.links = []
      base.queries = []
    end

    def self.href(*attrs)
      @href.concat attrs
    end

    def self.template(*attrs)
      @template.concat attrs
    end

    def self.links(*attrs)
      @links.concat attrs
    end

    def self.queries(*attrs)
      @queries.concat attrs
    end

    def self.items(&block)
      @_items = Items.new
      @_items.instance_eval(&block)
    end

    attr_accessor :resources

    def initialize(resource)
      @resources = if resource.respond_to? :to_ary
                     resource
                   else
                     [resource]
                   end
    end

    def href
      self.class.href.first
    end

    def template
      self.class.template
    end

    def links
      self.class.links
    end

    def queries
      self.class.queries
    end

    def items
      self.class._items
    end

    def invalid?
      Validator.new(self).invalid?
    end

    def valid?
      Validator.new(self).valid?
    end

    def errors
      Validator.new(self).errors
    end
  end
end
