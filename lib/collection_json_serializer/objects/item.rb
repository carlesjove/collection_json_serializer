module CollectionJsonSerializer
  class Serializer
    class Objects
      class Item
        def initialize(serializer)
          @serializer = serializer
        end

        def create
          h = Hash.new
          h.store :data, Array.new
          h.store(:links, Array.new) if @serializer.links.present?

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

          h
        end
      end
    end
  end
end
