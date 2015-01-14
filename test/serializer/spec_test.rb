require "minitest_helper"

module CollectionJson
  module Spec
    class TestSpec < Minitest::Test
      include TestHelper

      def test_that_random_attributes_cannot_be_passed
        serializer = empty_serializer_for(@user)
        serializer.items.attributes = [
          name: { unknown: "this should not be valid" }
        ]
        serializer.items.links = serializer.class.links = [
          dashboard: {
            href: "http://example.com",
            unknown: "this should not be valid"
          }
        ]
        serializer.class.template = [
          name: { whatever: "this should not be valid" }
        ]
        serializer.class.queries = [
          name: {
            href: "http://example.com",
            whatever: "this should be invalid",
            data: [
              unknown: "this should be invalid"
            ]
          }
        ]

        assert serializer.invalid?,
               "#{serializer.inspect} should be invalid"

        # Items attributes
        assert serializer.errors.key?(:attributes),
               "#{serializer.errors.inspect} should have key attributes"
        assert serializer.errors[:attributes][0].
          include?("attributes:name:unknown is an unknown attribute"),
          "#{serializer.errors[:attributes]} should include 'unknown attribute'"

        # Items links
        assert serializer.errors.key?(:items),
               "#{serializer.errors.inspect} should have key attributes"
        assert serializer.errors[:items][0].
          include?("items:links:dashboard:unknown is an unknown attribute")

        # Links
        assert serializer.errors.key?(:links), "should have error for 'links'"
        assert serializer.errors[:links][0].
          include?("links:unknown is an unknown attribute")

        # Template
        assert serializer.errors.key?(:template),
               "should have error for 'template'"
        assert serializer.errors[:template][0].
          include?("template:name:whatever is an unknown attribute")

        # Queries
        assert serializer.errors.key?(:queries),
               "should have error for 'queries'"
        assert serializer.errors[:queries][0].
          include?("queries:name:whatever is an unknown attribute")
        assert serializer.errors[:queries][1].
          include?("queries:name:data:unknown is an unknown attribute")
      end
    end
  end
end

