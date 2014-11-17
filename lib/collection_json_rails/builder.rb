module CollectionJsonRails
  class Serializer
    class Builder
      def initialize(serializer)
        @serializer = serializer
        @collection = {}
      end

      def add_item_attributes
        @collection.store :items, Array.new

        h = Hash.new
        h.store :data, Array.new
        h.store(:links, Array.new) if @serializer.links.present?

        # add item data
        @serializer.attributes.each do |attr, value|
          c = { name: attr, value: value }
          h[:data] << c
        end

        # add item links
        @serializer.links.each do |attr|
          case attr
          when Symbol
            # TODO: This way of building links kinda sucks :-(
            resource_base = @serializer.resource.account.class.to_s.downcase.pluralize
            resource_id = @serializer.resource.send(attr).id
            name = attr
            url = "/#{resource_base}/#{resource_id}"
          when Hash
            name = attr.keys.first
            url = attr[name][:href]
          end

          c = { name: name.to_s, href: url.to_s }
          h[:links] << c
        end if @serializer.links.present?

        @collection[:items] << h
      end

      def add_template_attributes
        @collection.store :template, Hash.new
        @collection[:template].store :data, Array.new

        @serializer.template.each do |attr|
          case attr
          when Hash
            name = attr.keys.first
            properties = attr[name]
          else
            name = attr
          end

          c = Hash.new
          c = { name: name, value: nil.to_s }
          properties.each {|k,v| c.store k, v } if properties
          @collection[:template][:data] << c
        end
      end

      def wrap
        @collection = { collection: @collection }
      end

      def to_json
        build!

        @collection.to_json
      end

      private

        def build!
          # There might be a more elegant way to do it, yes
          add_item_attributes
          add_template_attributes
          wrap
        end
    end
  end
end
