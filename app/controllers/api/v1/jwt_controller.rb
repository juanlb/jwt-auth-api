# frozen_string_literal: true

class Api::V1::JwtController < ApiController

  def auth
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
    if refresh_token.nil?
      render json: {}, status: :bad_request
    else
      jwt = JwtRefreshResponseGenerator.new(refresh_token.allowed_app).call
      render json: jwt
    end
  end

  def valid
    app = App.where(app_key: valid_params[:app_key]).take
    res = JwtChecker.new(app, valid_params[:jwt_token]).call
    render json: res[:response], status: res[:status]
  end

  def public_key
    app = App.where(app_key: public_key_params[:app_key]).take
    if app.nil?
      render json: {}, status: :bad_request
    else
      render json: {public_key: app.jwt_rsa_public_key}
    end
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

  def public_key_params
    params.require(:jwt).permit(:app_key)
  end
end
