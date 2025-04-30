require 'net/http'
require 'uri'

class ChainController < ApplicationController
  def health
    render plain: "OK"
  end

  def chain
    python_service_url = "http://python-service:8080/chain"
    
    uri = URI(python_service_url)
    response = Net::HTTP.get_response(uri)
    
    if response.is_a?(Net::HTTPSuccess)
      render plain: "Rails → Python: #{response.body.strip}", status: response.code
    else
      render plain: "Error calling Python service: #{response.message}", status: response.code
    end
  end
end
