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

module CollectionJsonSerializer
  module Support
    def extract_value_from(serializer, method)
      begin
        value = serializer.resource.send(method)
      rescue NoMethodError
        # ignore unknown attributes
      end

      value if value
    end
  end
end
