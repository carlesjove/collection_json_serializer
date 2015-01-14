require "minitest_helper"

module CollectionJson
  class Serializer
    class TestOpenAttrs < Minitest::Test
      include TestHelper

      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @serializer = empty_serializer_for(@user)
        @serializer.class.extensions = [:open_attrs]
        @serializer.class.template = [
          email: {
            prompt: "My email",
            anything: "at all"
          }
        ]
        @serializer.items.attributes = [
          name:
          {
            anything: "at all"
          }
        ]
        @serializer.items.links = [
          dashboard: {
            # TODO
            # This URL shouldn't validate!
            href: "/my-dashboard",
            anything: "at all"
          }
        ]
        @serializer.class.links = [
          dashboard: {
            href: "http://example.com/my-dashboard",
            anything: "at all"
          }
        ]
        @serializer.class.queries = [
          search: {
            href: "http://example.com/search",
            rel: "search",
            whatever: "doesn't matter",
            data: [
              name: "required",
              anything: "at all"
            ]
          }
        ]
      end

      def test_that_serializer_is_valid_using_open_attrs
        assert @serializer.valid?, "#{@serializer} should be valid"
      end

      def test_that_a_collection_can_be_built_using_open_attrs
        builder = Builder.new(@serializer)
        expected = {
          collection: {
            version: "1.0",
            items: [
              {
                data: [
                  {
                    name: "name",
                    value: "Carles Jove",
                    anything: "at all"
                  }
                ],
                links: [
                  {
                    rel: "dashboard",
                    href: "/my-dashboard",
                    name: "dashboard",
                    anything: "at all",
                  }
                ]
              }
            ],
            links: [
              {
                rel: "dashboard",
                href: "http://example.com/my-dashboard",
                name: "dashboard",
                anything: "at all",
              }
            ],
            template: {
              data: [
                {
                  name: "email",
                  value: "",
                  prompt: "My email",
                  anything: "at all"
                }
              ]
            },
            queries: [
              {
                href: "http://example.com/search",
                name: "search",
                whatever: "doesn't matter",
                rel: "search",
                data: [
                  name: "required",
                  anything: "at all",
                  value: ""
                ]
              }
            ]
          }
        }

        assert_equal JSON(expected.to_json), JSON(builder.to_json)
      end
    end
  end
end

