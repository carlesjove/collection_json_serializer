module CollectionJson
  class Serializer
    class Validator
      include CollectionJson::Serializer::Support

      attr_accessor :errors

      def initialize(serializer)
        @serializer = serializer
        @errors = {}
        validate
      end

      def valid?
        !invalid?
      end

      def invalid?
        @errors.any?
      end

      private

      def validate
        [
          :items,
          :href,
          :links,
          :template,
          :queries
        ].each { |m| send("validate_#{m}") }
      end

      def validate_items
        validate_items_attributes   if attributes?
        validate_items_links        if links?
      end

      def validate_items_attributes
        @serializer.items.attributes.each do |attr|
          params = attr.extract_params
          validate_attributes_values(@serializer.resources, params)
          validate_attributes_properties(params) if params[:properties]
        end if @serializer.items? && @serializer.items.attributes?
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

      def validate_items_links
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

      def value_is_invalid?(value)
        v = CollectionJson::Serializer::Validator::Value.new(value)
        v.invalid?
      end

      def url_is_invalid?(value)
        v = CollectionJson::Serializer::Validator::Url.new(value)
        v.invalid?
      end

      def error_for(kind, root: root, path: [])
        case kind.to_sym
        when :url
          ending = " is an invalid URL"
        when :value
          ending = " is an invalid value"
        when :missing_attribute
          ending = " is missing"
        when :unknown_attribute
          ending = " is an unknown attribute"
        else
          ending = " is an invalid value"
        end

        @errors[root] = [] unless @errors.key? root
        e = "#{@serializer.class} #{root}"
        e << ":" + path.join(":") if path.any?
        e << ending
        @errors[root] << e
      end

      def definition
        CollectionJson::Spec::DEFINITION
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
