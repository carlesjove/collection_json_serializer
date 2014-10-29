module CollectionJsonRails
  class Serializer
    class Builder
      def initialize(serializer)
        @serializer = serializer
        @collection = {}
      end

      def add_data_attributes
        @collection.store :items, Array.new

        h = Hash.new
        h.store :data, Array.new
        h.store(:links, Array.new) if @serializer.links.present?

        @serializer.data.each do |attr, value|
          c = { name: attr, value: value }
          h[:data] << c
        end

        @serializer.links.each do |attr|
          # TODO: This way of building links kinda sucks :-(
          resource_base = @serializer.resource.account.class.to_s.downcase.pluralize
          resource_id = @serializer.resource.send(attr).id
          c = { name: attr, href: "/#{resource_base}/#{resource_id}" }
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
          add_data_attributes
          add_template_attributes
          wrap
        end
    end
  end
end
