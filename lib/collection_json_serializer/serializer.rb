module CollectionJson
  class Serializer
    class << self
      attr_accessor :href
      attr_accessor :attributes
      attr_accessor :template
      attr_accessor :links
    end

    def self.inherited(base)
      base.href = []
      base.attributes = []
      base.template = []
      base.links = []
    end

    def self.href(*attrs)
      @href.concat attrs
    end

    def self.attributes(*attrs)
      @attributes.concat attrs
    end

    def self.template(*attrs)
      @template.concat attrs
    end

    def self.links(*attrs)
      @links.concat attrs
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

    def attributes
      self.class.attributes
    end

    def template
      self.class.template
    end

    def links
      self.class.links
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
