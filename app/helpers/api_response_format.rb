# helper to generate response in format {msg, status}
module ApiHelpers
  def generate_response (msg, success)
    JSON({:msg => msg , :success => success})
  end
end
