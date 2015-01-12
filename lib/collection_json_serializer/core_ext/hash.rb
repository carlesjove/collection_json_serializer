class Hash
  # Extract params
  # Returns a two-key hash where the first key is :name and the second is
  # :properties, being the latter a hash itself.
  #
  # hash = { hello: { prompt: "The prompt", value: "Hello World"" } }
  # hash.extract_params
  # => { name: "hello", properties: { prompt: "The prompt", value: "Hello World" } }
  def extract_params
    params = {}
    params[:name] = keys.first
    params[:properties] = self[keys.first]

    params
  end
end
