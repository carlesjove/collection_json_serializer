module CollectionJsonSerializer
  class Serializer
    class Validator
      include CollectionJsonSerializer::Support

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
          :attributes,
          :href,
          :links,
          :template
        ].each { |m| send("validate_#{m}") }
      end

      def validate_attributes
        @serializer.attributes.each do |attr|
          params = attr.extract_params

          value_error(
            extract_value_from(@serializer, params[:name]),
            root: :attributes,
            path: [params[:name]]
          )

          params[:properties].each do |key, value|
            value_error value, root: :attributes, path: [params[:name], key]
          end if params[:properties]

        end if @serializer.attributes.any?
      end

      def validate_href
        href = @serializer.href
        case href
        when String
          url_error href, root: :href
        when Hash
          href.each do |key, value|
            url_error value, root: :href, path: [key]
          end
        end
      end

      def validate_links
        @serializer.links.first.each do |k, link|
          unless link.key? :href
            @errors[:links] = [] unless @errors.key? :links
            e = "#{@serializer.class} links:#{k}:href is missing"
            @errors[:links] << e

            next
          end

          link.each do |key, value|
            case key
            when :href
              url_error link[:href], root: :links, path: [k, key]
            else
              value_error value, root: :links, path: [k, key]
            end
          end
        end if @serializer.links.present?
      end

      def validate_template
        @serializer.template.each do |attr|
          params = attr.extract_params

          params[:properties].each do |key, value|
            value_error value, root: :template, path: [params[:name], key]
          end if params[:properties]

        end if @serializer.template.any?
      end

      # Checks if a given value is invalid
      # and sets an error if it is
      def value_error(value, root:, path:)
        v = CollectionJsonSerializer::Serializer::Validator::Value.new(value)
        unless v.valid?
          @errors[root] = [] unless @errors.key? root
          e = "#{@serializer.class} #{root}:#{path.join(':')}"
          e << " is an invalid value"
          @errors[root] << e
        end
      end

      def url_error(value, root:, path: [])
        url = CollectionJsonSerializer::Serializer::Validator::Url.new(value)
        unless url.valid?
          @errors[root] = [] unless @errors.key? root
          e = "#{@serializer.class} #{root}"
          e << ":" + path.join(':') if path.any?
          e << " is an invalid URL"
          @errors[root] << e
        end
      end
    end
  end
end
