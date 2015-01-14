class Hash
  # Extract params
  # Returns a two-key hash where the first key is :name and the second is
  # :properties, being the latter a hash itself.
  #
  # hash = { hi: { prompt: "My prompt", value: "Hello!" } }
  # hash.extract_params
  # => { name: "hi", properties: { prompt: "My prompt", value: "Hello!" } }
  def extract_params
    params = {}
    params[:name] = keys.first
    params[:properties] = self[keys.first]

    params
  end
end
