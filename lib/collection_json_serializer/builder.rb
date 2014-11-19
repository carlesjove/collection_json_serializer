module CollectionJsonSerializer
  class Serializer
    class Builder
      def initialize(serializer)
        @serializer = serializer
        @collection = {}
      end

      def add_items
        @collection.store :items, Array.new
        item = CollectionJsonSerializer::Serializer::Objects::Item.new(@serializer)
        @collection[:items] << item.create
      end

      def add_template
        @collection.store :template, Hash.new
        template = CollectionJsonSerializer::Serializer::Objects::Template.new(@serializer)
        @collection[:template].store :data, template.create
      end

      def wrap
        @collection = { collection: @collection }
      end

      def to_json
        build and wrap
        @collection.to_json
      end

      private

        def build
          # There might be a more elegant way to do it, yes
          add_items
          add_template
        end
    end
  end
end
