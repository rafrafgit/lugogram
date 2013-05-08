class UserMailer < ActionMailer::Base
  default :from => "donotreply@example.com"
 
  def welcome_email(user)
    @user = user
    @url  = "http://lugogram.com/signin"
    mail(:to => user.email, :subject => "Welcome to Lugogram!")
  end

  def lugogram_email(user)
    layout = 'lugogram_email'
    @user = user
    @url  = "http://lugogram.com/signin"
    @lugogram_message = user.microposts[0].content
    mail(:to => user.email, :subject => "Lugogram for you")
  end

end