require "minitest_helper"

module CollectionJson
  class Serializer
    class Validator
      class TestInvalid < Minitest::Test
        include TestHelper

        def setup
          @user = User.new(
            name: "Carles Jove",
            email: "hola@carlus.cat"
          )
          @account = Account.new(
            id: 1,
            name: "My Account",
            created_at: Time.now
          )
          @user.account = @account

          @invalid = empty_serializer_for(@user)
        end

        # Href
        def test_that_href_generates_errors
          @invalid.class._href = [self: "/users/1", collection: "www.users.com"]

          assert @invalid.invalid?
          assert @invalid.errors.include? :href
          assert @invalid.errors[:href][0].
                  include? "href is an invalid URL"
          assert @invalid.errors[:href].length == 1

          @invalid.class._href = ["/users/1"]

          assert @invalid.invalid?
          assert @invalid.errors.include? :href
          assert @invalid.errors[:href][0].
                  include? "href is an invalid URL"
        end

        # Links
        def test_that_links_generates_errors
          @invalid.class._links = [dashboard: { href: "/my-dashboard" }]
          assert @invalid.invalid?
          assert @invalid.errors.include? :links
          assert @invalid.errors[:links].first.
                  include? "links:dashboard:href is an invalid URL"

          @invalid.class._links = [
            dashboard: {
              href: "http://valid.url.com",
              prompt: /invalid/
            }
          ]
          assert @invalid.invalid?
          assert @invalid.errors.include? :links
          assert @invalid.errors[:links].first.
                  include? "links:dashboard:prompt is an invalid value"
        end

        def test_that_links_missing_href_generates_error
          @invalid.class._links = [dashboard: {}]
          assert @invalid.invalid?
          assert @invalid.errors.include? :links
          assert @invalid.errors[:links].first.
                  include? "links:dashboard:href is missing"
        end

        # Attributes
        def test_that_invalid_attributes_return_values_generate_errors
          @invalid.items.attributes = [:name]

          values_for_test(:invalid).each do |invalidate|
            @user.name = invalidate
            assert @invalid.invalid?,
                   "#{invalidate} should be invalid"
            assert @invalid.errors.include?(:attributes),
                   "#{invalidate} should be invalid"
            assert @invalid.errors[:attributes].
                    first.include? "attributes:name is an invalid value"
          end
        end

        def test_that_invalid_attributes_properties_values_generate_errors
          values_for_test(:invalid).each do |invalidate|
            @invalid.items.attributes = [
              name: {
                prompt: invalidate
              }
            ]

            assert @invalid.invalid?,
                   "#{invalidate} should be invalid"
            assert @invalid.errors.include?(:attributes),
                   "#{invalidate} should be invalid"
            assert @invalid.errors[:attributes][0].
                    include? "attributes:name:prompt is an invalid value"
          end
        end

        # Template
        def test_that_template_values_validate
          values_for_test(:invalid).each do |invalidate|
            @invalid.class._template = [
              name: {
                prompt: invalidate,
                name: invalidate
              }
            ]

            assert @invalid.invalid?,
                   "#{invalidate} should be invalid"
            assert @invalid.errors.include?(:template),
                   "#{invalidate} should be invalid"
            assert @invalid.errors[:template][0].
                    include? "template:name:prompt is an invalid value"
            assert @invalid.errors[:template][1].
                    include? "template:name:name is an invalid value"
          end
        end

        # Queries
        def test_that_queries_validate_href_format
          @invalid.class._queries = [
            search: {
              href: "not-valid"
            }
          ]

          assert @invalid.invalid?,
                 "not-valid should be invalid"
          assert @invalid.errors.include?(:queries),
                 "not-valid should be invalid"
          assert @invalid.errors[:queries][0].
                  include? "queries:search:href is an invalid URL"
        end

        def test_that_queries_href_is_required
          @invalid.class._queries = [
            search: {
              name: "missing href"
            }
          ]

          assert @invalid.invalid?
          assert @invalid.errors.include?(:queries),
                 "should include queries errors"
          assert @invalid.errors[:queries][0].
                  include? "queries:search:href is missing"
        end

        def test_that_queries_values_are_validated
          values_for_test(:invalid).each do |invalidate|
            @invalid.class._queries = [
              search: {
                href: "http://example.com/",
                name: invalidate,
                rel: invalidate,
                data: [
                  name: invalidate
                ]
              }
            ]

            assert @invalid.invalid?,
                    "#{invalidate} should be invalid"
            assert @invalid.errors.include?(:queries),
                   "should include errors for queries"
            assert @invalid.errors[:queries][0].
                    include? "queries:search:name is an invalid value"
            assert @invalid.errors[:queries][1].
                    include? "queries:search:rel is an invalid value"
            assert @invalid.errors[:queries][2].
                    include? "queries:search:data:name is an invalid value"
          end
        end
      end
    end
  end
end
