module CollectionJson
  class Serializer
    class Objects
      class Query
        def initialize(serializer, item: 0)
          @serializer = serializer
          @index = item >= 0 ? item : 0
          @key = @serializer.queries.first.keys[@index]
          @resource = @serializer.queries.first[@key]
          @query = Hash.new
        end

        def create
          @query.store :rel, @key
          @query.store :href, @resource[:href]

          @query
        end
      end
    end
  end
end
