module CollectionJson
  class Serializer
    class Validation
      attr_accessor :errors

      def initialize(serializer)
        @serializer = serializer
        @errors = {}
        validate
      end

      def valid?
        !invalid?
      end

      def invalid?
        @errors.any?
      end

      private

      def validate
        raise NotImplementedError, "This should be implemented by validators"
      end

      def definition
        result = Hash.new
        CollectionJson::Spec.constants.each do |extension|
          # Skip the actual Spec::DEFINITION
          next if extension === :DEFINITION

          result.deep_merge!(definition_from(extension))
        end
        result.deep_merge(CollectionJson::Spec::DEFINITION)
      end

      def value_is_invalid?(value)
        v = Value.new(value)
        v.invalid?
      end

      def url_is_invalid?(value)
        v = Url.new(value)
        v.invalid?
      end

      def href_or_error(object, root: root, path: path)
        unless object.key?(:href)
          error_for :missing_attribute, root: root, path: path
        end
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
        when :unknown_extension
          ending = " is an unknown extension"
        else
          ending = " is an invalid value"
        end

        @errors[root] = [] unless @errors.key? root
        e = "#{@serializer.class} #{root}"
        e << ":" + path.join(":") if path.any?
        e << ending
        @errors[root] << e
      end

      def definition_from(extension_name)
        "CollectionJson::Spec::#{extension_name}".safe_constantize::DEFINITION
      end
    end
  end
end

