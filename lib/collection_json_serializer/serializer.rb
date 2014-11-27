module CollectionJsonSerializer
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

    def self.href(*url)
      @href.concat url
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

    attr_accessor :resource

    def initialize(resource)
      @resource = resource
    end

    def href
      self.class.href
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
  end
end
