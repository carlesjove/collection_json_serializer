class UserSerializer < CollectionJson::Serializer
  href "http://example.com/users"

  template :name
  template email: { prompt: "My email" }
  template :password

  link dashboard: { href: "http://example.com/my-dashboard" }

  query search: {
    href: "http://example.com/search",
    name: false
  }
  query pagination: {
    rel: "page",
    href: "http://example.com/page",
    prompt: "Select a page number",
    data: [
      { name: "page" }
    ]
  }

  items do
    href "http://example.com/users/{id}"
    attributes :name, :email
    attribute date_created: { prompt: "Member since" }
    link avatar: { href: "http://assets.example.com/avatar.jpg" }
    link bio: { href: "http://example.com/bio" }
  end
end
