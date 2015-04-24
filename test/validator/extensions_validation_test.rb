require "minitest_helper"

module CollectionJson::Spec
  module ExistingExtension
    DEFINITION = {}
  end
end

class UnexistingExtensionSerializer < CollectionJson::Serializer
  extensions :non_existing
end

module CollectionJson
  class Serializer
    class Validator
      class TestExtensionsValidation < Minitest::Test
        include TestHelper

        def setup
          @user = User.new(
            name: "Carles Jove",
            email: "hola@carlus.cat"
          )
        end

        def test_that_unknown_extensions_produce_an_error
          serializer = UnexistingExtensionSerializer.new(@user)

          assert_raises(NameError) do
            serializer.valid?
          end
        end

        def test_that_known_extensions_dont_producte_an_error
          serializer = empty_serializer_for(@user)
          serializer.class._extensions = [:existing_extension]

          assert serializer.valid?, "serializer should be valid"
        end

        def test_that_an_extension_with_no_definition_raises_proper_error
          skip
        end
      end
    end
  end
end
