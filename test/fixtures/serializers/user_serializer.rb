class UserSerializer < CollectionJson::Serializer
  href self: "http://example.com/users/{id}",
       collection: "http://example.com/users"
  template :name, email: { prompt: "My email" }
  links dashboard: { href: "http://example.com/my-dashboard" }
  queries search: {
    href: "http://example.com/search",
    name: false
  }, pagination: {
    rel: "page",
    href: "http://example.com/page",
    prompt: "Select a page number",
    data: [
      { name: "page" }
    ]
  }

  items do
    attributes :name, :email
    links avatar: { href: "http://assets.example.com/avatar.jpg" }
  end
end
