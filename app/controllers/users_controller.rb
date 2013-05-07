class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts
  end

  def index
    @users = User.all
  end

  def new
  end

  def create
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Lugogram!"
      redirect_to @user
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
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
