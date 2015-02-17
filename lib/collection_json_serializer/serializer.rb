module CollectionJson
  class Serializer
    class << self
      attr_accessor :_extensions
      attr_accessor :_href
      attr_accessor :_template
      attr_accessor :_links
      attr_accessor :_queries
      attr_accessor :_items
    end

    def self.inherited(base)
      base._extensions = []
      base._href = []
      base._template = []
      base._links = []
      base._queries = []
    end

    def self.extensions(*attrs)
      @_extensions.concat attrs
    end

    def self.href(*attrs)
      @_href.concat attrs
    end

    def self.template(*attrs)
      @_template.concat attrs
    end

    def self.link(*attrs)
      @_links.concat attrs
    end

    # DEPRECATED
    def self.links(*attrs)
      warn "Warning from collection_json_serializer\n" <<
           "`links` has been deprecated and will be removed soon. " <<
           "Please, use `link` instead"
      @_links.concat attrs
    end

    def self.query(*attrs)
      @_queries.concat attrs
    end

    def self.queries(*attrs)
      warn "Warning from collection_json_serializer\n" <<
           "`queries` has been deprecated and will be removed soon. " <<
           "Please, use `query` instead"
      @_queries.concat attrs
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

    def extensions
      self.class._extensions
    end

    def href
      self.class._href.first
    end

    def template
      self.class._template
    end

    def template?
      self.class._template.present?
    end

    def links
      self.class._links
    end

    def links?
      self.class._links.present?
    end

    def queries
      self.class._queries
    end

    def queries?
      self.class._queries.present?
    end

    def items
      self.class._items
    end

    def items?
      self.class._items.present?
    end

    def uses?(extension)
      extensions.include?(extension)
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
