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
    post.filter = getColor(users)  
    
    current_user.share(post, users) 
   
    url = root_url + "/?"
    post.getVisibility().each do |u| 
       url += "ids[]=" + u.id.to_s() + "&"
    end
    redirect_to url
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

    def getColor(users)

      num = 0;
      users.each do |u|
        num += u.id
      end  

      mimosa = '#EFC050'      #yellow
      honeysuckle = '#D65076' #pink
      tigerlily = '#E15D44'   #orange red     
      turquoise = '#45B8AC'   #turkoise green
      sand = '#DFCFBE'        #brown
      cerulean = '#98B4D4'    #blue
      yellow = '#f7e8aa'      #light yellow
      green = '#c9e8dd'       #light green
      aqua = '#7FCDCD'        #blue/green
      fuchsia = '#C3447A'     #lila
      
   
      colors = [yellow, green, honeysuckle, turquoise, mimosa, sand, tigerlily, aqua, fuchsia, cerulean]
      colors[num % colors.length]
    end 

end