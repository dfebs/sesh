class PasswordsMailer < ApplicationMailer
  default from: "hello@dfebs.com"

  def reset(user)
    @user = user
    mail to: user.email_address, subject: "Reset your password", track_opens: "true", message_stream: "outbound"
  end
end
