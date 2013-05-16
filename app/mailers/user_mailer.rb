class UserMailer < ActionMailer::Base
  default :from => "noreply@lugogram.com"

  def welcome_email(user)
    #@user = user
    #mail(:to => user.email, :subject => "Welcome to Lugogram!")

    @user = user
    @lugogram_message = "Welcome to Lugogram " + @user.name + "! Thanks for joining and have a great day!"
    @lugogram_color = '#DD4124'
    @lugogram_avatar = @user.avatar
    @lugogram_name = 'Staff'
    mail(:to => user.email, :subject => "Welcome to Lugogram!")

  end

  def lugogram_email(user)
    micropost = user.microposts[0]
    @user = user
    @lugogram_message = micropost.content
    @lugogram_color = micropost.filter
    @lugogram_avatar = @user.avatar
    @lugogram_name = @user.name
    @lugogram_url = 'http://lugogram.com'
    subject = "Message from " + @user.name
    mail(:to => micropost.recipients, :subject => subject) do |format|
      format.html { render :layout => "cute" }
      #format.text
    end
  end

end