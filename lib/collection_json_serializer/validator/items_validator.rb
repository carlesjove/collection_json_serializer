module CollectionJson
  class Serializer
    class Validator
      class ItemsValidator < Validation
        include CollectionJson::Serializer::Support

        private

        def validate
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
            link = attr.extract_params

            href_or_error(
              link[:properties],
              root: :items,
              path: [link[:name]]
            )

            link[:properties].each do |key, value|
              unless definition[:items][:links].keys.include?(key.to_sym)
                error_for(
                  :unknown_attribute,
                  root: :items,
                  path: [:links, link[:name], key]
                )
              end unless @serializer.uses?(:open_attrs)

              case key
              when :href
                if url_is_invalid?(value)
                  error_for(
                    :url,
                    root: :items,
                    path: [:links, link[:name], key]
                  )
                end
              else
                if value_is_invalid?(value)
                  error_for(
                    :value,
                    root: :items,
                    path: [:links, link[:name], key]
                  )
                end
              end
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

