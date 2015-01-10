class CustomItemSerializer < CollectionJson::Serializer
  items do
    attributes name: { anything: "at all", whatever: "really" }
  end
end
