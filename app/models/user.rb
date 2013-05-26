class User < ActiveRecord::Base
  attr_accessible :name, :email, :avatar, :password, :password_confirmation
  has_secure_password
  has_many :microposts
  has_many :friends, foreign_key: "user_id", dependent: :destroy


  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def sendWelcomeEmail
    UserMailer.welcome_email(self).deliver
  end


  def shareAndInvite(post)
    if post.save 
      @user = User.new()
      @user.email = post.recipients
      @user.avatar = "https://i0.wp.com/api.heroku.com/images/v3/profile/ninja-avatar-48x48.png?ssl=1"
      @user.name = @user.email
      @user.password = @user.email
      @user.password_confirmation = @user.password
      if @user.save
        self.addFriend(@user) 
        post.setVisibility([@user])
        UserMailer.lugogram_email(post, self, @user).deliver
      end  
    end  
  end

  def share(post, other_users)
    if post.save  
      post.setVisibility(other_users)
      other_users.each do |u|
        UserMailer.lugogram_email(post, self, u).deliver
      end  
    end  
  end  

  def getFriends
    returnUsers = []
    friends.each do |u|
      user = User.find_by_id(u.friend_id)
      if user == nil #if the user has been deleted in the meanwhile
        u.destroy #remove the friend
      else
        returnUsers.push(user)
      end  
    end
    returnUsers
  end 

  def isFriend?(other_user)
    if self.id == other_user.id
      true
    else    
      friends.find_by_friend_id(other_user.id)   
    end  
  end

  def addFriend(other_user)
    if !isFriend?(other_user)
      friends.create!(friend_id: other_user.id) unless self.id == other_user.id  
    end
  end

  def removeFriend(other_user)
    friends.find_by_friend_id(other_user.id).destroy
  end

  def getHistory
    post_ids = %(SELECT micropost_id FROM eyes WHERE user_id = :user_id)
    Micropost.where("id IN (#{post_ids}) or user_id = :user_id", { user_id: self })
  end  

  def hasNotLoggedIn
    self.name == self.email
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end


end