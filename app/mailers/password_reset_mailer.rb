class PasswordResetMailer < ApplicationMailer
  default from: 'noreply@dumbfound.com'

  def password_reset_email(user)
    @user = user
    mail(to: @user.email, subject: "Reset Your Dumbfound password")
  end
end
