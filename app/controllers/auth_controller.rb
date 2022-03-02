require 'jwt'

class AuthController < ApplicationController

  before_action :set_user_by_email, only: :login_with_email

  def login_with_email
    unless @user.nil?
      if params[:password] == @user.password
        render json: generate_new_tokens(@user.id), status: :ok
      else
        render json: {password: [ErrorMessage::WRONG_PASSWORD]}, status: :unauthorized
      end
    else
      render json: {email: [ErrorMessage::EMAIL_NOT_FOUND]}, status: :unauthorized
    end
  end

  def check_refresh_token
    begin
      params.require(:refresh)
    rescue ActionController::ParameterMissing
      render json: {refresh: [ErrorMessage::REFRESH_KEY_GET_ERROR]}, status: :unauthorized
      return
    end

    begin
      token_refresh = JWT.decode params[:refresh], @@secret_key, true, { algorithm: 'HS256' }
    rescue JWT::VerificationError, JWT::DecodeError
      render json: {refresh: [ErrorMessage::REFRESH_KEY_GET_ERROR]}, status: :unauthorized
      return
    end

    if token_refresh[0]["exp"] <= Time.now.to_i
      render json: {verification_error: [ErrorMessage::REFRESH_TOKEN_EXPIRED]}, status: :unauthorized
      return
    end

    begin
      User.find(token_refresh[0]["id"])
    rescue ActiveRecord::RecordNotFound
      render json: {verification_error: [ErrorMessage::INVALID_USER_TOKEN]}, status: :unauthorized
      return
    end

    render json: generate_new_tokens(token_refresh[0]["id"]), status: :ok
  end

  private

  def set_user_by_email
    params.permit(:email, :password)
    @user = User.where("email = ?", params[:email]).first
  end

  def generate_new_tokens user_id
    exp_access = Time.now.to_i + 3600
    exp_refresh = Time.now.to_i + 7 * 24 * 3600

    token_access = JWT.encode({exp: exp_access, id: user_id}, @@secret_key, 'HS256')
    token_refresh = JWT.encode({exp: exp_refresh, id: user_id}, @@secret_key, 'HS256')

    return {access: token_access, refresh: token_refresh}
  end
end
