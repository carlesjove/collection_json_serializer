$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "collection_json_serializer"

require "minitest/autorun"

require "fixtures/poro"
require "fixtures/models"
Dir.glob(File.dirname(__FILE__) + "/fixtures/serializers/**/*.rb") { |file| require file }

module TestHelper
  def empty_serializer_for(object)
    serializer = CollectionJson::Serializer.new(object)
    serializer.class.extensions = []
    serializer.class.href = []
    serializer.class.links = []
    serializer.class.template = []
    serializer.class.queries = []
    serializer.class.items {}
    serializer.items.attributes = []
    serializer
  end

  def values_for_test(of_kind)
    case of_kind
    when :invalid
      return [
        /regex/,
        :symbol,
        {},
        []
      ]
    when :valid
      return [
        "string",
        1,
        1.5,
        -1,
        BigDecimal.new(1),
        (22/7.0).to_r,
        true,
        false,
        nil
      ]
    end
  end

  def urls_for_test(of_kind)
    case of_kind
    when :invalid
      return %w(
        /hello
        http:hello
      )
    when :valid
      return %w(
        http://example.com
        https://example.com
        http://my.example.com
        https://my.example.com/?plus=query_string
      )
    end
  end
end
