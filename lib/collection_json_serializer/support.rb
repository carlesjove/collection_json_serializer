module CollectionJson
  class Serializer
    module Support
      def extract_value_from(resource, method)
        begin
          value = resource.send(method)
        rescue NoMethodError
          # ignore unknown attributes
        end

        value if value
      end

      def parse_url(url, object)
        segments = url.split("/")

        segments.each_with_index do |segment, index|
          if has_placeholder?(segment)
            action = segment.gsub(/[{}]/, "")
            segments[index] = object.send(action)
          end
        end if segments_with_placeholder?(segments)

        segments.join("/")
      end

      def segments_with_placeholder?(segments)
        segments.any? { |s| has_placeholder?(s) }
      end

      def has_placeholder?(string)
        string.chars.first.eql?("{") && string.chars.last.eql?("}")
      end
    end
  end
end
