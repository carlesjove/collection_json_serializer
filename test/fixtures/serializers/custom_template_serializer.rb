class CustomTemplateSerializer < CollectionJson::Serializer
  template :name, email: { prompt: "My email",
                           anything: "at all",
                           whatever: "really" }
end
