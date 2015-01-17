module CollectionJson
  class Serializer
    class Validator
      class ItemsValidator < Validator::Base
        include CollectionJson::Serializer::Support

        def initialize(serializer)
          super
          validate
        end

        private

        def validate
          #[:attributes].each { |m| send("validate_#{m}") }
          validate_attributes   if attributes?
          validate_links        if links?
        end

        def validate_attributes
          @serializer.items.attributes.each do |attr|
            params = attr.extract_params
            validate_attributes_values(@serializer.resources, params)
            validate_attributes_properties(params) if params[:properties]
          end if @serializer.items? && @serializer.items.attributes?
        end

        def validate_links
          @serializer.items.links.each do |attr|
            params = attr.extract_params
            params[:properties].keys.each do |key|
              unless definition[:items][:links].keys.include?(key.to_sym)
                error_for(
                  :unknown_attribute,
                  root: :items,
                  path: [:links, params[:name], key]
                )
              end unless @serializer.uses?(:open_attrs)
            end
          end
        end

        def validate_attributes_values(resources, params)
          resources.each do |resource|
            val = extract_value_from(resource, params[:name])
            if value_is_invalid?(val)
              error_for :value, root: :attributes, path: [params[:name]]
            end
          end
        end

        def value_is_invalid?(value)
          v = CollectionJson::Serializer::Validator::Value.new(value)
          v.invalid?
        end

        def validate_attributes_properties(params)
          params[:properties].each do |key, value|
            unless definition[:items][:data].keys.include?(key.to_sym)
              error_for(
                :unknown_attribute,
                root: :attributes,
                path: [params[:name], key]
              )
              next
            end unless @serializer.uses?(:open_attrs)

            if value_is_invalid?(value)
              error_for :value, root: :attributes, path: [params[:name], key]
            end
          end
        end

        def attributes?
          @serializer.items? && @serializer.items.attributes?
        end

        def links?
          @serializer.items? && @serializer.items.links?
        end
      end
    end
  end
end

