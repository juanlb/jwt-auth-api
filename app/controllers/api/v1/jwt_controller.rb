# frozen_string_literal: true

class Api::V1::JwtController < ApiController

  def auth
    allowed_app = input_validator.get_allowed_app
    jwt = JwtGenerator.new(allowed_app).call
    if jwt
      render json: jwt
    else
      render json: {}, status: :bad_request
    end
  end

  def refresh
    refresh_token = RefreshToken.where(token: refresh_params[:refresh_token]).take
    if refresh_token.nil?
      render json: {}, status: :bad_request
    else
      jwt = JwtGenerator.new(refresh_token.allowed_app).call
      render json: jwt
    end
  end

  def valid
    app = App.where(app_key: valid_params[:app_key]).take
    res = JwtChecker.new(app, valid_params[:jwt_token]).call
    render json: res[:response], status: res[:status]
  end

  private

  def input_validator
    @input_validator ||= JwtInputValidator.new(auth_params.to_h)
  end

  def auth_params
    params.require(:jwt).permit(:user_key, :app_key, :email, :password)
  end

  def refresh_params
    params.require(:jwt).permit(:refresh_token)
  end

  def valid_params
    params.require(:jwt).permit(:jwt_token, :app_key)
  end
end
