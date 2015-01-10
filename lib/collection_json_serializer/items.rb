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

      def links(*args)
        @links ||= args
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

