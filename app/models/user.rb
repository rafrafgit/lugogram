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

  def sendLugogramEmail
      UserMailer.lugogram_email(self).deliver
  end

  def share(message, other_users)
    post = microposts.build(content: message, filter: "#DD4124", recipients: "")
    if post.save  
      post.share(other_users)
    end  
  end  

  def getFriends
    returnUsers = []
    friends.each do |u|
      returnUsers.push(User.find_by_id(u.friend_id))
    end
    returnUsers
  end 

  def isFriend?(other_user)
    friends.find_by_friend_id(other_user.id)   
  end

  def addFriend(other_user)
    friends.create!(friend_id: other_user.id) unless self.id == other_user.id  
  end

  def removeFriend(other_user)
    friends.find_by_friend_id(other_user.id).destroy
  end

  def getHistory
    post_ids = %(SELECT micropost_id FROM eyes WHERE user_id = :user_id)
    Micropost.where("id IN (#{post_ids}) or user_id = :user_id", { user_id: self })
  end  


  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end


end