module CollectionJson
  class Serializer
    class Validator
      class Value
        VALID = %w(
          String
          Fixnum
          Float
          BigDecimal
          Rational
          TrueClass
          FalseClass
          NilClass
        )

        def initialize(value)
          @value = value
        end

        def valid?
          VALID.include? @value.class.to_s
        end

        def invalid?
          !valid?
        end
      end
    end
  end
end
