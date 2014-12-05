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
              href: "http://example.com/users/1",
              data: [
                { name: "name", value: "Carles Jove" },
                { name: "email", value: "hola@carlus.cat" }
              ],
              links: [
                { name: "dashboard", href: "http://example.com/my-dashboard" }
              ]
            }

            assert_equal expected.to_json, @item.create.to_json
          end

          def test_that_an_item_can_be_build_with_random_attributes
            custom_serializer = CustomItemSerializer.new(@user)
            item = Item.new(custom_serializer)

            expected = {
              data: [
                { name: "name", value: "Carles Jove", anything: "at all", whatever: "really" },
              ]
            }
            assert_equal expected.to_json, item.create.to_json
          end

          def test_that_an_item_link_can_be_build_with_unlimited_attributes
            custom_serializer = CustomItemLinksSerializer.new(@user)
            item = Item.new(custom_serializer)

            expected = {
              links: [
                { name: "dashboard", href: "/my-dashboard", anything: "at all", whatever: "really" }
              ]
            }

            assert_equal expected[:links], item.create[:links]
          end

          def test_that_unknown_attributes_are_silently_ignored
            serializer_with_unknown_attr = UnknownAttributeSerializer.new(@user)
            item = Item.new(serializer_with_unknown_attr)
            refute item.create.include?(:unknown)
          end
        end
      end
    end
  end
end
