class CustomItemLinksSerializer < CollectionJson::Serializer
  items do
    link dashboard: {
      href: "/my-dashboard",
      anything: "at all",
      whatever: "really"
    }
  end
end
