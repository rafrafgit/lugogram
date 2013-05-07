class UserMailer < ActionMailer::Base
  default :from => "donotreply@example.com"
 
  def welcome_email(user)
    @user = user
    @url  = "http://lugogram.com/signin"
    mail(:to => user.email, :subject => "Welcome to Lugogram!")
  end

  def lugogram_email(user)
    @user = user
    @url  = "http://lugogram.com/signin"
    @lugogram_message = user.microposts[0].content
    mail(:from => user.email, :to => user.email, :subject => "Micropost " + @lugogram_message)
  end

end