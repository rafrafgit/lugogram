class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user ,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    
    if @micropost.save  
      @userEyes = User.find(@micropost.recipients)
      @micropost.addEyes(@userEyes)

      #current_user.sendLugogramEmail
      #flash[:success] =  @micropost.content + " successfully sent to " + @micropost.recipients
      redirect_to root_url
    else
      render 'static_pages/home'
    end
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