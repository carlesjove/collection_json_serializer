module CollectionJson
  class Serializer
    class Validator
      class Base
        attr_accessor :errors

        def initialize(serializer)
          @serializer = serializer
          @errors = {}
        end

        private

        def definition
          CollectionJson::Spec::DEFINITION
        end

        def error_for(kind, root: root, path: [])
          case kind.to_sym
          when :url
            ending = " is an invalid URL"
          when :value
            ending = " is an invalid value"
          when :missing_attribute
            ending = " is missing"
          when :unknown_attribute
            ending = " is an unknown attribute"
          else
            ending = " is an invalid value"
          end

          @errors[root] = [] unless @errors.key? root
          e = "#{@serializer.class} #{root}"
          e << ":" + path.join(":") if path.any?
          e << ending
          @errors[root] << e
        end
      end
    end
  end
end

