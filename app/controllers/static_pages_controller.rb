class StaticPagesController < ApplicationController
  before_filter :signed_in_user

  def home
    @micropost = current_user.microposts.build if signed_in?
    @friends = current_user.getFriends
    @microposts = current_user.getHistory
  end

  def help
  end
end
