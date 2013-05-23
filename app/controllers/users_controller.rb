class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @friend  = User.new(params[:friend])
    @friends = @user.getFriends
    @microposts = @user.getHistory
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    @user.avatar = "https://www.lugogram.com/images/ninja-avatar-48x48.png"
    if @user.save
      sign_in @user

      admin = User.find(1)
      admin.share("Welcome to Lugogram!", [@user])
      @user.addFriend(admin)

      flash[:success] = "Welcome to Lugogram! " + @user.name
      redirect_to root_url
      #UserMailer.welcome_email(@user).deliver
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.id == current_user.id #unless it is admin deleting users
      sign_out
    end
    redirect_to root_url
  end  

  def friend
    @userToFriend = User.find(params[:friend_id])
    current_user.addFriend(@userToFriend)
    #flash[:success] = "Friend added " + @userToFriend.name
    redirect_to @userToFriend    
  end
    
  def unfriend
    @userToUnFriend = User.find(params[:friend_id])
    current_user.removeFriend(@userToUnFriend)
    #flash[:success] = "Friend removed " + @userToUnFriend.name
    redirect_to @userToUnFriend
  end

  def invite
    @user = User.new(params[:user])
    existing_user = User.find_by_email(@user.email)
    if existing_user
      if current_user.isFriend?(existing_user)
        flash[:success] = existing_user.name + " (" + existing_user.email + ") is already at Lugogram and You are already friends :)"  
      else  
        flash[:success] = existing_user.name + " (" + existing_user.email + ") is already at Lugogram. You are now friends :)"
        current_user.addFriend(existing_user) 
      end  
    else  
      @user.avatar = "https://www.lugogram.com/images/ninja-avatar-48x48.png"
      @user.name = "guest"
      @user.password = "guest123"
      @user.password_confirmation = @user.password
      if @user.save
        current_user.addFriend(@user) 
        current_user.sendInviteEmail(@user)
        flash[:success] = @user.email + " invited."
      end
    end  
    redirect_to root_url
  end  


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
