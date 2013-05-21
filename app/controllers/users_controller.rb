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
      flash[:success] = "Welcome to Lugogram!"
      redirect_to root_url
      UserMailer.welcome_email(@user).deliver
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


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
