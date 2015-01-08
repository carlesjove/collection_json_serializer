module CollectionJson
  class Serializer
    class Items
      attr_accessor :attributes
      attr_accessor :links

      def attributes(*args)
        @attributes ||= args
      end

      def links(*args)
        @links ||= args
      end
    end
  end
end

