class WelcomeMailer < ApplicationMailer
default from: 'noreply@dumbfound.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Test Email")
  end
end
