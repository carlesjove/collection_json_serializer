module CollectionJsonRails
  class Serializer
    class << self
      attr_accessor :data
    end

    def self.inherited(base)
      base.data = []
    end

    def self.data(*attrs)
      @data.concat attrs
    end

    attr_accessor :resource

    def initialize(resource)
      @resource = resource
    end
  end
end
