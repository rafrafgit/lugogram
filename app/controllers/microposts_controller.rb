class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user ,   only: :destroy

  def create
   
   friends_params = params[:friends]
   post_params = params[:micropost]

   users = []
   friends_params.each do |key, value|
    if value != nil && value == "true"
      users.push(User.find(key))
    end
   end

   current_user.share(post_params["content"], users) 
   redirect_to root_url
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end

end