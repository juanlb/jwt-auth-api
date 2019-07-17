# frozen_string_literal: true

class Api::V1::AuthController < ApiController

  def login
    allowed_app = input_validator.get_allowed_app
    jwt = JwtRefreshResponseGenerator.new(allowed_app).call
    if jwt
      render json: jwt
    else
      render json: {}, status: :bad_request
    end
  end

  def refresh
    refresh_token = RefreshToken.where(token: refresh_params[:refresh_token]).take
    if refresh_token.nil? or refresh_token.allowed_app.app_id != @app.id
      render json: {}, status: :bad_request
    else
      jwt = JwtRefreshResponseGenerator.new(refresh_token.allowed_app).call
      render json: jwt
    end
  end

  def valid
    res = JwtChecker.new(@app, valid_params[:jwt]).call
    render json: res[:response], status: res[:status]
  end

  def public_key
    if @app.nil?
      render json: {}, status: :bad_request
    else
      render json: {public_key: @app.rsa_public_key}
    end
  end

  private

  def input_validator
    @input_validator ||= JwtInputValidator.new(login_params.to_h, @app)
  end

  def login_params
    params.require(:auth).permit(:user_key, :app_key, :email, :password)
  end

  def refresh_params
    params.require(:auth).permit(:refresh_token)
  end

  def valid_params
    params.require(:auth).permit(:jwt, :app_key)
  end
end
