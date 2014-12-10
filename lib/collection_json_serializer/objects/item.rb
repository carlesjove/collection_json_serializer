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
            start_object :data, Array.new

            params = attr.extract_params
            value = extract_value_from(@serializer, params[:name])

            c = { name: params[:name], value: value } if value
            c.merge!(params[:properties]) if params[:properties]

            @item[:data] << c
          end if @serializer.attributes.present?
        end

        def add_links
          @serializer.links.each do |attr|
            start_object :links, Array.new

            params = attr.extract_params
            c = {
              name: params[:name].to_s,
              href: params[:properties][:href]
            }

            c.merge!(params[:properties]) if params[:properties]

            @item[:links] << c
          end if @serializer.links.present?
        end

        def start_object(name, type)
          @item.store(name.to_sym, type) unless @item.key? name.to_sym
        end
      end
    end
  end
end
