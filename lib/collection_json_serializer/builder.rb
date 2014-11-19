module CollectionJsonSerializer
  class Serializer
    class Builder
      def initialize(serializer)
        @serializer = serializer
        @collection = {}
      end

      def add_item_attributes
        @collection.store :items, Array.new
        item = CollectionJsonSerializer::Serializer::Objects::Item.new(@serializer)
        @collection[:items] << item.create
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
