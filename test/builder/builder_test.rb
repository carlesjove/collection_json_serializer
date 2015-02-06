require "minitest_helper"

module CollectionJson
  class Serializer
    class Builder
      class TestBuilder < Minitest::Test
        def setup
          @user1 = User.new(name: "Carles Jove", email: "hola@carlus.cat")
          @user2 = User.new(name: "Aina Jove", email: "hola@example.com")
          @account = Account.new(id: 1, name: "My Account", created_at: Time.now)
          @user1.account = @account
        end

        def test_response_format_with_one_resource
          user_serializer = UserSerializer.new(@user1)
          builder = Builder.new(user_serializer)
          expected = {
            collection: {
              version: "1.0",
              href: "http://example.com/users",
              items: [
                {
                  href: "http://example.com/users/#{@user1.id}",
                  data: [
                    {
                      name: "name",
                      value: "Carles Jove"
                    },
                    {
                      name: "email",
                      value: "hola@carlus.cat"
                    }
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
              ],
              links: [
                {
                  rel: "dashboard",
                  href: "http://example.com/my-dashboard",
                  name: "dashboard"
                }
              ],
              template: {
                data: [
                  {
                    name: "name",
                    value: ""
                  },
                  {
                    name: "email",
                    value: "",
                    prompt: "My email"
                  },
                  {
                    name: "password",
                    value: ""
                  }
                ]
              },
              queries: [
                {
                  rel: "search",
                  href: "http://example.com/search"
                }
              ]
            }
          }

          assert_equal expected.to_json, builder.to_json
        end

        def test_response_format_with_multiple_resources
          user_serializer = UserSerializer.new([@user1, @user2])
          builder = Builder.new(user_serializer)
          expected = {
            collection: {
              version: "1.0",
              href: "http://example.com/users",
              items: [
                {
                  href: "http://example.com/users/#{@user1.id}",
                  data: [
                    {
                      name: "name",
                      value: "Carles Jove"
                    },
                    {
                      name: "email",
                      value: "hola@carlus.cat"
                    }
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
                },
                {
                  href: "http://example.com/users/#{@user2.id}",
                  data: [
                    {
                      name: "name",
                      value: "Aina Jove"
                    },
                    {
                      name: "email",
                      value: "hola@example.com"
                    }
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
              ],
              links: [
                {
                  rel: "dashboard",
                  href: "http://example.com/my-dashboard",
                  name: "dashboard"
                }
              ],
              template: {
                data: [
                  {
                    name: "name",
                    value: ""
                  },
                  {
                    name: "email",
                    value: "",
                    prompt: "My email"
                  },
                  {
                    name: "password",
                    value: ""
                  }
                ]
              },
              queries: [
                {
                  rel: "search",
                  href: "http://example.com/search"
                }
              ]
            }
          }

          assert_equal expected.to_json, builder.to_json
        end

        def test_that_an_invalid_serializer_raises_an_error
          invalid_serializer = InvalidSerializer.new(@user1)
          builder = Builder.new(invalid_serializer)

          assert_raises Exception do
            builder.pack
          end
        end
      end
    end
  end
end
