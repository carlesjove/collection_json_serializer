module CollectionJsonRails
  class Serializer
    class << self
      attr_accessor :data
      attr_accessor :template
      attr_accessor :links
    end

    def self.inherited(base)
      base.data = []
      base.template = []
      base.links = []
    end

    def self.data(*attrs)
      @data.concat attrs
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

    def data
      h = Hash.new
      self.class.data.each do |attr|
        h[attr] = @resource.send(attr)
      end
      h
    end

    def template
      self.class.template
    end

    def links
      self.class.links
    end
  end
end
