class UsersController < ApplicationController
  rate_limit to: 100, within: 1.minute
  # TODO: make this apparent to the person trying to send an email again within 1 minute of the first time
  rate_limit to: 1, within: 1.minute, only: :send_confirmation_email
  allow_unauthenticated_access only: [ :new, :create ]

  def create
    @user = User.new(user_params)
    if @user.save then
      redirect_to new_session_path, notice: "User successfully created, time to log in!"
    else
      flash.now[:alert] = @user.errors.full_messages.join("")
      render :new, status: :unprocessable_entity
    end
  end

  def new
  end

  def edit
    @user = Current.user
  end

  def confirm_email
    @user = User.find_by_token_for(:email_confirmation, params[:token])
    @user.email_confirmed = true
    @user.save!
  end

  def send_confirmation_email
    @user = User.find(params[:id])
    UserMailer.with(user: @user).email_confirmation.deliver_later
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Confirmation email sent. It will reach your inbox shortly." }
    end
  end

  private

  def user_params
    params.expect user: [ :email_address, :password, :password_confirmation ]
  end
end
