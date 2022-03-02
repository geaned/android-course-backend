require 'error_messages'

class ApplicationController < ActionController::API
  extend ErrorMessage

  private

  def validate_query
    begin
      # remove "Bearer " in the beginning
      token_access_encoded = request.headers["Authorization"][7..-1]
    rescue NoMethodError
      render json: {verification_error: [ErrorMessage::ACCESS_KEY_GET_ERROR]}, status: :unauthorized
      return
    end

    begin
      token_access = JWT.decode token_access_encoded, @@secret_key, true, { algorithm: 'HS256' }
    rescue JWT::VerificationError, JWT::DecodeError
      render json: {verification_error: [ErrorMessage::ACCESS_KEY_GET_ERROR]}, status: :unauthorized
      return
    end
    
    if token_access[0]["exp"] <= Time.now.to_i
      render json: {verification_error: [ErrorMessage::ACCESS_TOKEN_EXPIRED]}, status: :unauthorized
      return
    end

    @user_id = token_access[0]["id"]
    begin
      User.find(@user_id)
    rescue ActiveRecord::RecordNotFound
      render json: {verification_error: [ErrorMessage::INVALID_USER_TOKEN]}, status: :unauthorized
      return
    end
  end

  @@secret_key = "gHeFofjk3pIcSu2hSstIai9hbmdnrbS3cr3tK3yX6U6CtNtPpzUqVSsvxzcnObC"
end
