class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user ,   only: :destroy

  def create   
   friends_params = params[:friends]
   post = current_user.microposts.build(params[:micropost])
   users = []
   if friends_params != nil
     friends_params.each do |key, value|
      if value != nil && value == "true"
        users.push(User.find(key))
      end
     end
   end  
   current_user.share(post, users) 
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