module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end 

  def defaultAvatar
    "/images/glyphicons_003_user.png"
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def randomColor
     
    emerald = '#009B77'
    tangerine = '#DD4124'
    honeysuckle = '#D65076'
    turquoise = '#45B8AC'
    mimosa = '#EFC050'
    izis = '#5B5EA6'
    sand = '#DFCFBE'
    tigerlily = '#E15D44'
    aqua = '#7FCDCD'
    fuchsia = '#C3447A' 
    cerulean = '#98B4D4'
 
    colors = [emerald, tangerine, honeysuckle, turquoise, mimosa, izis, sand, tigerlily, aqua, fuchsia, cerulean]
    colors[rand(colors.length)]
  end
  
end
