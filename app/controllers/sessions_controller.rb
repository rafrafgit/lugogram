class SessionsController < ApplicationController

	def new
    end

	def create
  	  user = User.find_by_email(params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
	    sign_in user
	    if (user.name == user.email)
	    	admin = User.find(1)
      		admin.share("Welcome to Lugogram!", [user])
      		user.addFriend(admin)
      		flash.now[:success] = 'Welcome! Please add your name and password.'
      		redirect_to edit_user_path(user)
	    else
        	redirect_to root_url
        end	
	  else
	    flash.now[:error] = 'Invalid email/password combination ' + params[:session][:email].downcase + " and " + params[:session][:password]
        render 'new'
	  end
	end

	def destroy
		sign_out
    	redirect_to root_url
    end

end
