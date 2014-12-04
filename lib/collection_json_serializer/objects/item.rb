module CollectionJsonSerializer
  class Serializer
    class Objects
      class Item
        def initialize(serializer)
          @serializer = serializer
          @item = Hash.new
        end

        def create
          add_href if @serializer.href.present?
          add_data
          add_links if @serializer.links.present?

          @item
        end

        private

        def add_href
          @item.store :href, @serializer.href[:self] || @serializer.href
        end

        def add_data
          @item.store :data, Array.new

          # add item data
          @serializer.attributes.each do |attr|
            case attr
            when Hash
              name = attr.keys.first
              properties = attr[name]
            else
              name = attr
            end

            begin
              value = @serializer.resource.send(name)
            rescue NoMethodError
              # ignore unknown attributes
            end

            c = { name: name, value: value } if value
            properties.each { |k, v| c.store k, v } if properties
            @item[:data] << c
          end
        end

        def add_links
          @item.store(:links, Array.new)

          @serializer.links.each do |attr|
            case attr
            when Hash
              name = attr.keys.first
              url = attr[name][:href]
              properties = attr[name]
            end

            c = { name: name.to_s, href: url.to_s }
            properties.each { |k, v| c.store k, v } if properties
            @item[:links] << c
          end
        end
      end
    end
  end
end
