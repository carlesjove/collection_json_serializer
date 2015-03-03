class Symbol
  def extract_params
    params = {}
    params[:name] = self

    params
  end

  def to_constant
    Object.const_get(self.to_s.split('_').map{|w| w.capitalize}.join)
  end
end
