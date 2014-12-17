class UserSerializer < CollectionJson::Serializer
  href self: "http://example.com/users/{id}",
       collection: "http://example.com/users"
  attributes :name, :email
  template :name, email: { prompt: "My email" }
  links dashboard: { href: "http://example.com/my-dashboard" }
  queries search: {
    href: "http://example.com/search",
    name: false
  }
end
