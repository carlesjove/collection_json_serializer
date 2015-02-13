module CollectionJson
  class Serializer
    class Items
      attr_accessor :href
      attr_accessor :attributes
      attr_accessor :links

      def href(*args)
        url = if args.first.is_a?(Array)
                args.first.first
              else
                args.first
              end
        @href ||= url
      end

      def attributes(*args)
        @attributes ||= args
      end

      def attribute(args)
        @attributes = Array.new unless @attributes.is_a?(Array)
        @attributes << args
      end

      def link(args)
        @links = Array.new unless @links.is_a?(Array)
        @links << args
      end

      def links
        @links
      end

      def href?
        @href.present?
      end

      def attributes?
        @attributes.present?
      end

      def links?
        @links.present?
      end
    end
  end
end

