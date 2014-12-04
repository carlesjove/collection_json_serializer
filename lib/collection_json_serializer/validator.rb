module CollectionJsonSerializer
  class Serializer
    class Validator
      attr_accessor :errors

      def initialize(serializer)
        @serializer = serializer
        @errors = []
        validate
      end

      def valid?
        true unless @errors.any?
      end

      def invalid?
        true if @errors.any?
      end

      private 

      def validate
        validate_href
      end

      def validate_href
        href = @serializer.href
        case href
        when String
          url = CollectionJsonSerializer::Serializer::Validator::Url.new(href)
          @errors << "#{@serializer.class} href is an invalid URL" unless url.valid?
        when Hash
          href.each do |key, value|
            url = CollectionJsonSerializer::Serializer::Validator::Url.new(value)
            @errors << "#{@serializer.class} href:#{key} is an invalid URL" unless url.valid?
          end
        end
      end
    end
  end
end
