class CustomItemLinksSerializer < CollectionJson::Serializer
  items do
    links dashboard: {
      href: "/my-dashboard",
      anything: "at all",
      whatever: "really"
    }
  end
end
