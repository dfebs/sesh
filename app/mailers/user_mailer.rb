class UserMailer < ApplicationMailer
  default from: 'hello@dfebs.com'

  def email_confirmation
    @user = params[:user]
    mail to: @user.email_address, from: "hello@dfebs.com", track_opens: "true", message_stream: "outbound"
  end
end
