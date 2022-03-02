class UsersController < ApplicationController

  before_action :validate_query
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_users_by_text, only: :index

  def index
    # basic format
    render json: remove_public_data(@users)
  end

  def create
    @user = User.create!(user_data)
    render json: @user, status: :created
  end

  def show
    # full format on id match, else basic format
    if @user_id == params[:id].to_i
      render json: @user
    else
      render json: remove_public_data(@user)
    end
  end

  def update
    # update only own user
    if @user_id == params[:id].to_i
      @user.update(user_data)
    end
    head :no_content
  end

  def destroy
    # destroy only own user
    if @user_id == params[:id].to_i
      @user.destroy
    end
    head :no_content
  end

  def show_self
    # full format
    render json: User.find(@user_id)
  end

  private

  def user_data
    params.permit(:user_name, :first_name, :last_name, :picture, :about_me, :email, :phone_number, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_users_by_text
    text = request.query_parameters.has_key?("textSearchQuery") ? params["textSearchQuery"] : ""
    @users = User.where(["user_name like ? OR first_name like ? OR last_name like ?", "%#{text}%", "%#{text}%", "%#{text}%"])
  end

  def remove_public_data users_entity
    if users_entity.is_a?(User)
      return users_entity.slice(:id, :user_name, :first_name, :last_name, :picture, :about_me)
    end

    # implies it is a User::ActiveRecord_Relation
    return users_entity.select("id", "user_name", "first_name", "last_name", "picture", "about_me")
  end
end
