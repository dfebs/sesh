class UserMailer < ApplicationMailer
  def email_confirmation
    @user = params[:user]
    mail to: @user.email_address
  end
end
