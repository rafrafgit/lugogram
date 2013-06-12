class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :index

  def home
    if signed_in?
      @micropost = current_user.microposts.build if signed_in?
      @friend  = User.new()
      @friends = current_user.getFriends
      @visible_users = []
      @microposts = nil
      visible_ids = params[:ids]
        
      if visible_ids != nil
        visible_ids.each do |id|
          @visible_users.push(User.find(id)) unless current_user.id.to_s == id
        end
        @microposts = current_user.getVisiblePosts(@visible_users)    
      else
        @microposts = current_user.getHistory
      end 
    end  
  end

  def edit
    @micropost = current_user.microposts.build #remove later
    
    @user = User.find(params[:id])
    @friend  = User.new()
    @friends = @user.getFriends
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @micropost = current_user.microposts.build #remove later
    @friend  = User.new() #remove later
    @friends = current_user.getFriends #remove later
    @visible_users = [] #remove later

    @users = User.all
  end

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    existing_user = User.find_by_email(@user.email.downcase)
    if existing_user
       if existing_user.hasNotLoggedIn
          if existing_user.update_attributes(params[:user])
            sign_in existing_user
            sendWelcomeMessage(existing_user) 
            flash[:success] = "Welcome to Lugogram! " + existing_user.name
            redirect_to root_url 
          end   
       else
        render 'new'
      end 
    else  
      if @user.save
        sign_in @user
        sendWelcomeMessage(@user) 
        flash[:success] = "Welcome to Lugogram! " + @user.name
        redirect_to root_url
      else
        render 'new'
      end
    end
  end

  

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated"
    end
    redirect_to root_url
  end

  def destroy
    User.find(params[:id]).destroy 
    redirect_to root_url
  end  

  def friend
    @userToFriend = User.find(params[:friend_id])
    current_user.addFriend(@userToFriend)
    #flash[:success] = "Friend added " + @userToFriend.name
    redirect_to root_url 
  end
    
  def unfriend
    @userToUnFriend = User.find(params[:friend_id])
    current_user.removeFriend(@userToUnFriend)
    #flash[:success] = "Friend removed " + @userToUnFriend.name
    redirect_to root_url
  end

  def invite
    @user = User.new(params[:user])
    existing_user = User.find_by_email(@user.email.downcase)
    if existing_user
      if current_user.isFriend?(existing_user)
        flash[:success] = "You are already friends with " + existing_user.name  + " :)" 
      else  
        flash[:success] = "You are now friends with " + existing_user.name  + " :)"
        current_user.addFriend(existing_user) 
      end  
    else  
      @user.name = @user.email.downcase
      @user.password = "guest123"
      @user.password_confirmation = @user.password
      if @user.save
        current_user.addFriend(@user) 
        @user.addFriend(current_user)           #this should be removed later
        flash[:success] = @user.email + " added."
      end
    end  
    redirect_to root_url
  end  


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def sendWelcomeMessage(user)
      # Send welcome message from Lugogram Staff:
      admin = User.find(1)
      post = admin.microposts.build()
      post.content = "Welcome to Lugogram " + user.name + "!"
      
      if post.save  
        #Set visibility
        visible = []
        visible.push(user)
        visible.push(admin)
        post.setVisibility(visible)
        admin.share(post) 
      end  
    end
end
