module CollectionJsonSerializer
  class Serializer
    class Objects
      class Item
        include CollectionJsonSerializer::Support

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
            params = attr.extract_params
            value = extract_value_from(@serializer, params[:name])

            c = { name: params[:name], value: value } if value
            c.merge!(params[:properties]) if params[:properties]

            @item[:data] << c
          end
        end

        def add_links
          @item.store(:links, Array.new)

          @serializer.links.each do |attr|
            params = attr.extract_params
            c = {
              name: params[:name].to_s,
              href: params[:properties][:href]
            }

            c.merge!(params[:properties]) if params[:properties]

            @item[:links] << c
          end
        end
      end
    end
  end
end
