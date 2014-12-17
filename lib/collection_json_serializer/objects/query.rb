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
          @query[:rel]  = @resource[:rel] || @key
          @query[:href] = @resource[:href]

          # Optional fields
          @query[:name]   = extract_name if name?
          @query[:prompt] = @resource[:prompt] if @resource[:prompt]
          @query[:data]   = add_data if @resource[:data]

          @query
        end

        private

        def extract_name
          @resource[:name].present? ? @resource[:name] : @key
        end

        def add_data
          @resource[:data].each_with_object([]) do |attr, data|
            data << { name: attr[:name], value: nil.to_s }
          end
        end

        def name?
          @resource[:name] != false
        end
      end
    end
  end
end
