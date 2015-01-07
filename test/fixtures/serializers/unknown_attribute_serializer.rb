class UnknownAttributeSerializer < CollectionJson::Serializer
  items do
    attributes :unknown
  end
end
