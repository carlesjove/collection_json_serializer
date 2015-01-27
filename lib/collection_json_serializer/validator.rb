module CollectionJson
  class Serializer
    class Validator < Validation
      include CollectionJson::Serializer::Support

      private

      def validate
        definition.keys.each do |m|
          method = "validate_#{m}"
          send(method) if respond_to?(method, true)
        end
      end

      def validate_items
        items_validation = ItemsValidator.new(@serializer)
        @errors.merge!(items_validation.errors)
      end

      def validate_href
        href = @serializer.href
        case href
        when String
          error_for :url, root: :href if url_is_invalid? href
        when Hash
          href.each do |key, value|
            error_for :url, root: :href, path: [key] if url_is_invalid? value
          end
        end
      end

      def validate_links
        @serializer.links.first.each do |k, link|
          unless link.key? :href
            error_for :missing_attribute, root: :links, path: [k, :href]

            next
          end

          link.each do |key, value|
            unless definition[:links].keys.include?(key.to_sym)
              error_for :unknown_attribute, root: :links, path: [key]
              next
            end unless @serializer.uses?(:open_attrs)

            case key
            when :href
              if url_is_invalid? link[:href]
                error_for :url, root: :links, path: [k, key]
              end
            else
              if value_is_invalid? value
                error_for :value, root: :links, path: [k, key]
              end
            end
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

            if value_is_invalid?(value)
              error_for :value, root: :template, path: [params[:name], key]
            end
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

          if url_is_invalid?(params[:properties][:href])
            error_for :url, root: :queries, path: [params[:name], "href"]
          end

          params[:properties].each do |key, value|
            next if key == :data || key == :href
            unless definition[:queries].keys.include?(key.to_sym)
              error_for(
                :unknown_attribute,
                root: :queries,
                path: [params[:name], key]
              )
            end unless @serializer.uses?(:open_attrs)

            if value_is_invalid?(value)
              error_for :value, root: :queries, path: [params[:name], key]
            end
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

              if value_is_invalid?(hash[:name])
                error_for :value,
                          root: :queries,
                          path: [params[:name], "data", "name"]
              end
            end
          end
        end if @serializer.queries.present?
      end
    end
  end
end
