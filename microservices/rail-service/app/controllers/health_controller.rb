class HealthController < ActionController::API
  def check
    render json: { status: 'ok' }
  end
end