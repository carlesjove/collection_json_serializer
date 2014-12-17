module CollectionJson
  class Serializer
    class Objects
      class Query
        def initialize(serializer, item: 0)
          @serializer = serializer
          @index = item >= 0 ? item : 0
          @resource = @serializer.queries[@index]
          @key = @serializer.queries[@index].keys.first
          @query = Hash.new
        end

        def create
          @query.store :rel, @key
          @query.store :href, extract_href

          @query
        end

        private

        def extract_href
          @resource[@key][:href]
        end
      end
    end
  end
end
