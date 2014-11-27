module CollectionJsonSerializer
  class Serializer
    class Builder
      def initialize(serializer)
        @serializer = serializer
        @collection = { version: "1.0" }
      end

      def pack
        build
        { collection: @collection }
      end

      def to_json
        pack.to_json
      end

      private

      def build
        # There might be a more elegant way to do it, yes
        add_href if @serializer.href.present?
        add_items if @serializer.attributes.present?
        add_template if @serializer.template.present?
      end

      def add_href
        # TODO: only one value should be allowed
        @collection.store :href, @serializer.href.first
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
    end
  end
end
