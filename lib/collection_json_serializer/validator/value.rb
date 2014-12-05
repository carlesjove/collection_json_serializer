module CollectionJsonSerializer
  class Serializer
    class Validator
      class Value
        VALID = %w(
          String
          Symbol
          Fixnum
          Float
          TrueClass
          FalseClass
          NilClass
        )

        def initialize(value)
          @value = value
        end

        def valid?
          true if VALID.include? @value.class.to_s
        end

        def invalid?
          true unless valid?
        end
      end
    end
  end
end
