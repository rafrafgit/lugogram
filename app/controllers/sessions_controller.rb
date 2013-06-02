class SessionsController < ApplicationController

	def new
    end

	def create
  	  user = User.find_by_email(params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
	    sign_in user
	    if (user.hasNotLoggedIn)
	    	admin = User.find(1)
	    	#post = admin.microposts.build()
	    	#post.content = "Welcome to Lugogram!"
      		#admin.share(post, [user])
      		user.addFriend(admin)
      		flash[:success] = 'Welcome! Please add your name and password.'
      		redirect_to edit_user_path(user)
      		#UserMailer.welcome_email(user).deliver
	    else
        	redirect_to root_url
        end	
	  else
	    flash.now[:error] = 'Invalid email/password combination'
        render 'new'
	  end
	end

	def destroy
		sign_out
    	redirect_to root_url
    end

end
