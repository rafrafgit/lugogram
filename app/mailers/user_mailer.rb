class UserMailer < ActionMailer::Base
  default :from => "Lugogram@lugogram.com"

  def lugogram_email(post, from_user, to_user)  
    @user = from_user
    @lugogram_url = 'https://lugogram.herokuapp.com'
    @lugogram_message = post.content
    @lugogram_color = post.filter
    @lugogram_weblink = post.weblink
    @lugogram_imagelink = post.imagelink
    @lugogram_avatar = @user.getAvatarURL
    @lugogram_avatar = ""
    if (@user.avatar == nil or @user.avatar.length == 0)
      @lugogram_avatar = @lugogram_url + "/images/" + @user.getAvatarURL
    else
      @lugogram_avatar = @user.getAvatarURL
    end  
    
    @lugogram_name = @user.name

    subject = "Message from " + @user.name
    mail(:to => to_user.email, :subject => subject) do |format|
      format.html { render :layout => "cute" }
      #format.text
    end
  end

end