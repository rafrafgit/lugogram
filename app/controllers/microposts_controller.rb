class MicropostsController < ApplicationController
  before_filter :signed_in_user

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      current_user.sendLugogramEmail
      flash[:success] = "Micropost created! Email delivered." + @micropost.content + " with style: " + @micropost.filter 
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end
end