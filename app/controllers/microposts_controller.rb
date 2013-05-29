class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user ,   only: :destroy

  def create   
   friends_params = params[:friends]
   post = current_user.microposts.build(params[:micropost])

   if(post.recipients != nil and post.recipients.length > 0)      #if user has sent to an email address, invite that user to join if it is not already a member
    existing_user = User.find_by_email(post.recipients.downcase)
    if existing_user                                    #if user has send an email to an existing user, add her as a friend and send message
      current_user.addFriend(existing_user)
      current_user.share(post, [existing_user]) 
    else                                                #else invite user
      current_user.shareAndInvite(post)
    end  
   else                                             #else send message to all friends
     users = []
     friends_params.each do |key, value|
      if value != nil && value == "true"
        users.push(User.find(key))
      end
     end
     current_user.share(post, users) 
   end
   redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = "Post deleted :)"
    end
    redirect_to root_url
  end

  def show
    @micropost = current_user.microposts.find_by_id(params[:id])
    if (@micropost.nil? or !@micropost.isVisible(current_user))
      redirect_to root_url 
    end  
  end  

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      
      if @micropost.nil?
        flash[:error] = "Could not find post to delete :("
        redirect_to root_url 
      end  
    end

end