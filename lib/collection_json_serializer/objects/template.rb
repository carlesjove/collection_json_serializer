module CollectionJsonSerializer
  class Serializer
    class Objects
      class Template
        def initialize(serializer)
          @serializer = serializer
          @data = Array.new
        end

        def create
          @serializer.template.each do |attr|
            params = attr.extract_params

            c = { name: params[:name], value: nil.to_s }

            params[:properties].each do |k, v|
              c.store k, v
            end if params[:properties]

            @data << c
          end

          @data
        end
      end
    end
  end
end
