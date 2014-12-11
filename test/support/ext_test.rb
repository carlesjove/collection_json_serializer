require "minitest_helper"

module CollectionJsonSerializer
  class Serializer
    class TestExtractParams < Minitest::Test
      def test_extract_params_for_hash
        attrs = { test: { prompt: "works" } }

        params = attrs.extract_params
        assert_equal :test, params[:name]
        assert_equal attrs[:test], params[:properties]
      end

      def test_extract_params_for_symbol
        attrs = :test

        params = attrs.extract_params
        assert_equal :test, params[:name]
        assert params[:properties].nil?
      end
    end
  end
end
