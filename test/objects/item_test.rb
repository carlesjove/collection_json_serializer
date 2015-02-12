require "minitest_helper"

module CollectionJson
  class Serializer
    class Objects
      class Item
        class TestItem < Minitest::Test
          include TestHelper

          def setup
            @user1 = User.new(name: "Carles Jove", email: "hola@carlus.cat", date_created: "2015-02-01")
            @user2 = User.new(name: "Aina Jove", email: "hola@example.com", date_created: "2015-02-02")
            @user_serializer = UserSerializer.new(@user1)
            @item = Item.new(@user_serializer)
          end

          def test_that_an_item_can_be_build
            expected = {
              href: "http://example.com/users/#{@user1.id}",
              data: [
                { name: "name", value: "Carles Jove" },
                { name: "email", value: "hola@carlus.cat" },
                { name: "date_created", value: "2015-02-01", prompt: "Member since" }
              ],
              links: [
                {
                  rel: "avatar",
                  href: "http://assets.example.com/avatar.jpg",
                  name: "avatar"
                },
                {
                  rel: "bio",
                  href: "http://example.com/bio",
                  name: "bio"
                }
              ]
            }

            assert_equal expected.to_json, @item.create.to_json
          end

          def test_that_an_item_can_be_built_passing_an_index
            user_serializer = UserSerializer.new([@user1, @user2])
            item = Item.new(user_serializer, item: 1)

            expected = {
              href: "http://example.com/users/#{@user2.id}",
              data: [
                { name: "name", value: "Aina Jove" },
                { name: "email", value: "hola@example.com" },
                { name: "date_created", value: "2015-02-02", prompt: "Member since" }
              ],
              links: [
                {
                  rel: "avatar",
                  href: "http://assets.example.com/avatar.jpg",
                  name: "avatar"
                },
                {
                  rel: "bio",
                  href: "http://example.com/bio",
                  name: "bio"
                }
              ]
            }

            assert_equal expected.to_json, item.create.to_json
          end

          def test_that_unknown_attributes_are_silently_ignored
            serializer = empty_serializer_for(@user1)
            serializer.items.attributes(:unknown)
            item = Item.new(serializer)

            refute item.create.include?(:unknown)
          end
        end
      end
    end
  end
end
