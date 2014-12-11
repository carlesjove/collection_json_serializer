class UserSerializer < CollectionJson::Serializer
  href self: "http://example.com/users/1",
       collection: "http://example.com/users"
  attributes :name, :email
  template :name, email: { prompt: "My email" }
  links dashboard: { href: "http://example.com/my-dashboard" }
end
