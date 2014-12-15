module CollectionJson
  class Serializer
    class Objects
      class Item
        include CollectionJson::Serializer::Support

        def initialize(serializer)
          @serializer = serializer
          @item = Hash.new
        end

        def create
          add_href  if @serializer.href.present?
          add_data  if @serializer.attributes.present?
          add_links if @serializer.links.present?

          @item
        end

        private

        def add_href
          if @serializer.href.present?
            @item.store :href, @serializer.href[:self] || @serializer.href
          end
        end

        def add_data
          @serializer.attributes.each do |attr|
            params = attr.extract_params
            value = extract_value_from(@serializer.resource, params[:name])

            next unless value

            c = { name: params[:name], value: value }
            c.merge!(params[:properties]) if params[:properties]

            start_object :data, Array.new
            @item[:data] << c
          end if @serializer.attributes.present?
        end

        def add_links
          @serializer.links.each do |attr|
            params = attr.extract_params

            next unless params.key? :properties

            start_object :links, Array.new
            @item[:links] << {
              name: params[:name].to_s,
              href: params[:properties][:href]
            }.merge!(params[:properties])
          end if @serializer.links.present?
        end

        def start_object(name, type)
          @item.store(name.to_sym, type) unless @item.key? name.to_sym
        end
      end
    end
  end
end
