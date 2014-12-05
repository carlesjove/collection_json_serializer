module CollectionJsonSerializer
  class Serializer
    class Validator
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
        [:attributes, :href, :links].each { |m| send("validate_#{m}") }
      end

      def validate_attributes
        @serializer.attributes.each do |attr|

          case attr
          when Hash
            name = attr.keys.first
            properties = attr[name]
          else
            name = attr
          end

          begin
            value = @serializer.resource.send(name)
          rescue NoMethodError
            # ignore unknown attributes
          end

          value = CollectionJsonSerializer::Serializer::Validator::Value.new(value)
          unless value.valid?
            @errors[:attributes] = [] unless @errors.key? :attributes
            e = "#{@serializer.class} attributes:#{name}"
            e << " is an invalid value"
            @errors[:attributes] << e
          end

          properties.each do |k, v|
            v = CollectionJsonSerializer::Serializer::Validator::Value.new(v)
            unless v.valid?
              @errors[:attributes] = [] unless @errors.key? :attributes
              e = "#{@serializer.class} attributes:#{name}:#{k}"
              e << " is an invalid value"
              @errors[:attributes] << e
            end
          end if properties

        end if @serializer.attributes.any?
      end

      def validate_href
        href = @serializer.href
        case href
        when String
          url = CollectionJsonSerializer::Serializer::Validator::Url.new(href)
          unless url.valid?
            @errors[:href] = [] unless @errors.key? :href
            @errors[:href] << "#{@serializer.class} href is an invalid URL"
          end
        when Hash
          href.each do |key, value|
            url = CollectionJsonSerializer::Serializer::Validator::Url.new(value)
            unless url.valid?
              @errors[:href] = [] unless @errors.key? :href
              e = "#{@serializer.class} href:#{key} is an invalid URL"
              @errors[:href] << e
            end
          end
        end
      end

      def validate_links
        @serializer.links.first.each do |key, link|
          link.each do |key, value|
            case key
            when :href
              url = CollectionJsonSerializer::Serializer::Validator::Url.new(link[:href])
              unless url.valid?
                @errors[:links] = [] unless @errors.key? :links
                e = "#{@serializer.class} links:#{key}:href is an invalid URL"
                @errors[:links] << e
              end
            else
              v = CollectionJsonSerializer::Serializer::Validator::Value.new(value)
              unless v.valid?
                @errors[:links] = [] unless @errors.key? :links
                e = "#{@serializer.class} links:#{key}"
                e << " is an invalid value"
                @errors[:links] << e
              end
            end
          end
        end if @serializer.links.present?
      end
    end
  end
end
