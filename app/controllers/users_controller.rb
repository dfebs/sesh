class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  def show
    @user = Current.user
  end

  def create
    @user = User.new(user_params)
    if @user.save then
      redirect_to new_session_path, notice: "User successfully created, time to log in!"
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def new
  end

  private

  def user_params
    params.expect user: [:email_address, :password, :password_confirmation]
  end
end
