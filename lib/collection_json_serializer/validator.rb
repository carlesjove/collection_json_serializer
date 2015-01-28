module CollectionJson
  class Serializer
    class Validator < Validation
      include CollectionJson::Serializer::Support

      private

      def validate
        deep_validate
        definition.keys.each do |m|
          method = "validate_#{m}"
          send(method) if respond_to?(method, true)
        end
      end

      def validate_items
        items_validation = ItemsValidator.new(@serializer)
        @errors.merge!(items_validation.errors)
      end

      def validate_links
        @serializer.links.each do |link|
          params = link.extract_params

          unless params[:properties].key?(:href)
            error_for :missing_attribute, root: :links, path: [params[:name], :href]

            next
          end

          params[:properties].each do |key, value|
            unless definition[:links].keys.include?(key.to_sym)
              error_for :unknown_attribute, root: :links, path: [key]
              next
            end unless @serializer.uses?(:open_attrs)

            attribute_validation(key, value, [:links, params[:name], key])
          end
        end if @serializer.links.present?
      end

      def validate_template
        @serializer.template.each do |attr|
          params = attr.extract_params

          params[:properties].each do |key, value|
            unless definition[:template].keys.include?(key.to_sym)
              error_for(
                :unknown_attribute,
                root: :template,
                path: [params[:name], key]
              )
              next
            end unless @serializer.uses?(:open_attrs)

            attribute_validation(key, value, [:template, params[:name], key])
          end if params[:properties]

        end if @serializer.template.any?
      end

      def validate_queries
        @serializer.queries.each do |query|
          params = query.extract_params

          unless params[:properties].key?(:href)
            error_for :missing_attribute,
                      root: :queries,
                      path: [params[:name], "href"]

            next
          end

          attribute_validation(:href, params[:properties][:href], [:queries, params[:name], "href"])

          params[:properties].each do |key, value|
            next if key == :data || key == :href
            unless definition[:queries].keys.include?(key.to_sym)
              error_for(
                :unknown_attribute,
                root: :queries,
                path: [params[:name], key]
              )
            end unless @serializer.uses?(:open_attrs)

            attribute_validation(key, value, [:queries, params[:name], key])
          end

          if params[:properties].key?(:data)
            params[:properties][:data].each do |hash|
              hash.keys.each do |key|
                unless definition[:queries][:data].keys.include?(key)
                  error_for(
                    :unknown_attribute,
                    root: :queries,
                    path: [params[:name], :data, key]
                  )
                end unless @serializer.uses?(:open_attrs)
              end

              attribute_validation(:data, hash[:name], [:queries, params[:name], "data", "name"])
            end
          end
        end if @serializer.queries.present?
      end

      def deep_validate
        definition.keys.each do |key|
          next unless @serializer.respond_to?(key, true)

          value = @serializer.send(key)
          attribute_validation(key, value, [key]) if key == :href
        end
      end

      def attribute_validation(key, value, path)
        case key
        when :href
          if url_is_invalid?(value)
            error_for :url, root: path.shift, path: path
          end
        else
          if value_is_invalid?(value)
            error_for :value, root: path.shift, path: path
          end
        end
      end

    end
  end
end
