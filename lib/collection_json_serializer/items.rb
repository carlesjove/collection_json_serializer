module CollectionJson
  class Serializer
    class Items
      attr_accessor :attributes

      def attributes(*args)
        @attributes ||= args
      end
    end
  end
end

