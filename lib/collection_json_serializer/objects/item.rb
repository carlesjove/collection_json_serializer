module CollectionJsonSerializer
  class Serializer
    class Objects
      class Item
        def initialize(serializer)
          @serializer = serializer
          @item = Hash.new
        end

        def create
          add_data
          add_links if @serializer.links.present?

          @item
        end

        private

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
            when Symbol
              # TODO: This way of building links kinda sucks :-(
              resource_base = @serializer.resource.account.class.to_s.downcase.pluralize
              resource_id = @serializer.resource.send(attr).id
              name = attr
              url = "/#{resource_base}/#{resource_id}"
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