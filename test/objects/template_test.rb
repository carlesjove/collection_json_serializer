require "minitest_helper"

module CollectionJsonSerializer
  class Serializer
    class Objects
      class Template
        class TestTemplate < Minitest::Test
          def setup
            @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
            @account = Account.new(id: 1, name: "My Account", created_at: Time.now)
            @user.account = @account
            @user_serializer = UserSerializer.new(@user)
            @template = Template.new(@user_serializer)
          end

          def test_that_a_template_can_be_build
            expected = [
              { name: "name", value: "" },
              { name: "email", value: "", prompt: "My email" }
            ]

            assert_equal expected.to_json, @template.create.to_json
          end

          def test_that_a_template_can_be_build_with_random_attributes
            custom_serializer = CustomTemplateSerializer.new(@user)
            template = Template.new(custom_serializer)

            expected = [
              { name: "name", value: "" },
              { name: "email", value: "", prompt: "My email", anything: "at all", whatever: "really" }
            ]

            assert_equal expected.to_json, template.create.to_json
          end
        end
      end
    end
  end
end
