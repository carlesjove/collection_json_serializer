class Hash
  def extract_params
    params = {}
    params[:name] = keys.first
    params[:properties] = self[keys.first]

    params
  end
end
