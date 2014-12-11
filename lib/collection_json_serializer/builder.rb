module CollectionJson
  class Serializer
    class Builder
      def initialize(serializer)
        @serializer = serializer
        @collection = { version: "1.0" }
      end

      def pack
        if @serializer.errors.any?
          error = "The #{@serializer.class} has errors: "
          @serializer.errors.each_value { |v| error << v.join(", ") }
          raise Exception, error
        else
          build
          { collection: @collection }
        end
      end

      def to_json
        pack.to_json
      end

      private

      def build
        # There might be a more elegant way to do it, yes
        add_href if @serializer.href.respond_to? :key
        add_items if @serializer.attributes.present?
        add_template if @serializer.template.present?
      end

      def add_href
        if @serializer.href.key? :collection
          @collection.store :href, @serializer.href[:collection]
        end
      end

      def add_items
        @collection.store :items, Array.new
        item = CollectionJson::Serializer::Objects::Item.new(@serializer)
        @collection[:items] << item.create
      end

      def add_template
        @collection.store :template, Hash.new
        template = CollectionJson::Serializer::Objects::Template.new(@serializer)
        @collection[:template].store :data, template.create
      end
    end
  end
end
