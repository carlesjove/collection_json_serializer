module CollectionJson
  class Serializer
    class Validator
      class Url
        # Stolen from https://github.com/eparreno/ruby_regex/blob/master/lib/ruby_regex.rb
        VALID = /(\A\z)|(\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z)/ix

        def initialize(value)
          @uri = value
        end

        def valid?
          true unless VALID.match(@uri).nil?
        end

        def invalid?
          true unless valid?
        end
      end
    end
  end
end
