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
            case attr
            when Hash
              name = attr.keys.first
              properties = attr[name]
            else
              name = attr
            end

            c = Hash.new
            c = { name: name, value: nil.to_s }
            properties.each { |k, v| c.store k, v } if properties
            @data << c
          end

          @data
        end
      end
    end
  end
end
