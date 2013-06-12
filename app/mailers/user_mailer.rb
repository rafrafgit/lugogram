class UserMailer < ActionMailer::Base
  default :from => "Lugogram <lugogram@lugogram.com>"

  def lugogram_email(post, from_user, to_user)  
    @user = from_user
    url = 'https://lugogram.herokuapp.com'
    @lugogram_message = post.content
    @lugogram_color = post.getColor()
    @lugogram_weblink = post.weblink
    @lugogram_imagelink = post.imagelink
    @lugogram_avatar = @user.getAvatarURL
    @lugogram_avatar = ""
    if (@user.avatar == nil or @user.avatar.empty? or @user.avatar.start_with?("/images"))
      @lugogram_avatar = url + @user.getAvatarURL
    else
      @lugogram_avatar = @user.getAvatarURL
    end 

    @lugogram_url = url + "/?"
    post.getVisibility().each do |u| 
       @lugogram_url += "ids[]=" + u.id.to_s() + "&"
    end

    @lugogram_name = @user.name

    subject = "Message from " + @user.name
    mail(:to => to_user.email, :subject => subject) do |format|
      format.html { render :layout => "cute" }
      #format.text
    end
  end

end