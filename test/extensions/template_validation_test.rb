require "minitest_helper"

module CollectionJson
  class Serializer
    class TestTemplateValidation < Minitest::Test
      include TestHelper

      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @serializer = empty_serializer_for(@user)
        @serializer.class._extensions = [:template_validation]
        @serializer.class._template = [
          email: {
            regexp: "^[a-zA-Z0-9]*$",
            required: true
          }
        ]
      end

      def test_that_serializer_is_invalid_when_not_using_template_validations
        serializer = empty_serializer_for(@user)
        serializer.class._template = [
          email: {
            regexp: "^[a-zA-Z0-9]*$",
            required: true
          }
        ]

        assert serializer.invalid?
      end

      def test_that_serializer_is_valid_using_template_validations
        assert @serializer.valid?, "should be valid using :template_validation"
      end

      def test_that_a_collection_can_be_built_using_template_validations
        builder = Builder.new(@serializer)
        expected = {
          collection: {
            version: "1.0",
            template: {
              data: [
                {
                  name: "email",
                  value: "",
                  regexp: "^[a-zA-Z0-9]*$",
                  required: true
                }
              ]
            }
          }
        }

        assert_equal JSON(expected.to_json), JSON(builder.to_json)
      end
    end
  end
end

