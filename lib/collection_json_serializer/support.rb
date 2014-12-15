class Hash
  def extract_params
    params = {}
    params[:name] = keys.first
    params[:properties] = self[keys.first]

    params
  end
end

class Symbol
  def extract_params
    params = {}
    params[:name] = self

    params
  end
end

module CollectionJson
  class Serializer
    module Support
      def extract_value_from(resource, method)
        begin
          value = resource.send(method)
        rescue NoMethodError
          # ignore unknown attributes
        end

        value if value
      end
    end
  end
end
