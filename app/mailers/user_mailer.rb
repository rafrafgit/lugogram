class UserMailer < ActionMailer::Base
  default :from => "donotreply@example.com"

  def welcome_email(user)
    @user = user
    @url  = "http://lugogram.com/signin"
    mail(:to => user.email, :subject => "Welcome to Lugogram!")
  end

  def lugogram_email(user)
    micropost = user.microposts[0]
    #layout = micropost.filter
    @user = user
    @lugogram_message = micropost.content
    mail(:to => user.email, :subject => "Lugogram for you") do |format|
      format.html { render :layout => micropost.filter }
      #format.text
    end
  end

end