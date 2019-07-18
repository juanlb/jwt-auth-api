# frozen_string_literal: true

class ApiController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authorize_request

  protected

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      @decoded = JsonWebToken.decode(header)
      @app = App.find(@decoded[:app_id])
      raise 'Invalid app_key' unless @app.app_key == @decoded[:app_key]
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue StandardError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
