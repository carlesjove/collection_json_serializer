class ValidSerializer < CollectionJson::Serializer
  href self: "http://example.com/users/1",
       collection: "http://example.com/users"
  links dashboard: { href: "http://example.com/my-dashboard" }
end
