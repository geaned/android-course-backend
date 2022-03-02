class RegistrationController < ApplicationController
  
  def create
    @user = User.new(user_data)
    if @user.valid?
      @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unauthorized
    end
  end

  private

  def user_data
    params.permit(:user_name, :first_name, :last_name, :picture, :about_me, :email, :phone_number, :password)
  end
end
