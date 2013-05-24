class UserMailer < ActionMailer::Base
  default :from => "Lugogram@lugogram.com"

  def welcome_email(user)
    @user = user
    @lugogram_message = "Welcome to Lugogram " + @user.name + "! Thanks for joining and have a great day!"
    @lugogram_color = '#DD4124'
    @lugogram_avatar = @user.avatar
    @lugogram_name = 'Staff'
    mail(:to => user.email, :subject => "Welcome to Lugogram!")
  end

  def lugogram_email(post, from_user, to_user)  
    @user = from_user
    @lugogram_url = 'http://www.lugogram.com'
    @lugogram_message = post.content
    @lugogram_color = post.filter
    @lugogram_avatar = @user.avatar
    @lugogram_name = @user.name

    if(to_user.hasNotLoggedIn) 
      @lugogram_url = @lugogram_url + "/login?session%5Bemail%5D=" + Rack::Utils.escape(to_user.email) + "&session%5Bpassword%5D=" + Rack::Utils.escape(to_user.password)
    end
    subject = "Message from " + @user.name
    mail(:to => to_user.email, :subject => subject) do |format|
      format.html { render :layout => "cute" }
      #format.text
    end
  end

end