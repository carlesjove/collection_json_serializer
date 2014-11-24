require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class Objects
      class Item
        class TestItem < Minitest::Test
          def setup
            @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
            @account = Account.new(id: 1, name: "My Account", created_at: Time.now)
            @user.account = @account
            @user_serializer = UserSerializer.new(@user)
            @item = Item.new(@user_serializer)
          end

          def test_that_an_item_can_be_build
            expected = {
              data: [
                { name: "name", value: "Carles Jove" },
                { name: "email", value: "hola@carlus.cat" }
              ],
              links: [
                { name: "account", href: "/accounts/#{@account.id}" },
                { name: "dashboard", href: "/my-dashboard" }
              ]
            }

            assert_equal expected.to_json, @item.create.to_json
          end
        end
      end
    end
  end
end
