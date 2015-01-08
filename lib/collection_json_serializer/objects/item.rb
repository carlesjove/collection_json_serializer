module CollectionJson
  class Serializer
    class Objects
      class Item
        include CollectionJson::Serializer::Support

        def initialize(serializer, item: 0)
          @serializer = serializer
          @index = item >= 0 ? item : 0
          @resource = @serializer.resources[@index]
          @item = Hash.new
        end

        def create
          add_href  if href?
          add_data  if items? && attributes?
          add_links if links?

          @item
        end

        private

        def add_href
          if @serializer.href.present?
            @item.store :href, set_href
          end
        end

        def add_data
          attributes.each do |attr|
            params = attr.extract_params
            value = extract_value_from(@resource, params[:name])

            next unless value

            c = { name: params[:name], value: value }
            c.merge!(params[:properties]) if params[:properties]

            start_object :data, Array.new
            @item[:data] << c
          end if attributes?
        end

        def add_links
          @serializer.items.links.each do |attr|
            params = attr.extract_params

            next unless params.key? :properties

            start_object :links, Array.new
            @item[:links] << {
              rel: set_rel(params),
              href: params[:properties][:href],
              name: params[:name].to_s
            }.merge!(params[:properties])
          end if @serializer.items.links.present?
        end

        def start_object(name, type)
          @item.store(name.to_sym, type) unless @item.key? name.to_sym
        end

        def set_href
          url = @serializer.href[:self] || @serializer.href
          parse_url(url, @resource)
        end

        def set_rel(params)
          if params[:properties].key? :rel
            params[:properties][:rel].to_s
          else
            params[:name].to_s
          end
        end

        def href?
          @serializer.href.present?
        end

        def links?
          @serializer.items.links.present?
        end

        def items?
          !@serializer.items.nil?
        end

        def attributes?
          @serializer.items.attributes.present?
        end

        def attributes
          @serializer.items.attributes if attributes?
        end
      end
    end
  end
end
