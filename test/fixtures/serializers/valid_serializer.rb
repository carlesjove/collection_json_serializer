class ValidSerializer < CollectionJsonSerializer::Serializer
  href self: "http://example.com/users/1", collection: "http://example.com/users"
end
