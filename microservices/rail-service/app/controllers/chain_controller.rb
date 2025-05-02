class ChainController < ActionController::API
  def forward
    begin
      response = Faraday.get('http://python-service:8000/chain')
      
      if response.status == 200
        parsed = JSON.parse(response.body)
        render json: {
          service_name: 'rails-frontend',
          status: 'ok',
          role: 'Frontend UI',
          python_gateway_response: parsed
        }
      else
        render json: { error: "Python service returned status #{response.status}" }, status: :service_unavailable
      end
    rescue Faraday::ConnectionFailed => e
      render json: { error: "Connection to Python service failed: #{e.message}" }, status: :service_unavailable
    rescue StandardError => e
      render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
    end
  end
end