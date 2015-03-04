require "minitest_helper"

module CollectionJson::Spec
  module ExistingExtension
    DEFINITION = {}
  end
end

module CollectionJson
  class Serializer
    class Validator
      class TestExtensionsValidation < Minitest::Test
        def setup
          @user = User.new(
            name: "Carles Jove",
            email: "hola@carlus.cat"
          )
          @serializer = UserSerializer.new(@user)
        end

        def test_that_unknown_extensions_produce_an_error
          @serializer.class._extensions = [:unknown_extension]

          assert @serializer.invalid?, "serializer should be invalid"
          assert @serializer.errors.include?(:extensions)
        end

        def test_that_known_extensions_dont_producte_an_error
          @serializer.class._extensions = [:existing_extension]

          assert @serializer.valid?, "serializer should be valid"
        end

        def test_that_an_extension_with_no_definition_raises_proper_error
          skip
        end
      end
    end
  end
end
