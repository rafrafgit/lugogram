class Micropost < ActiveRecord::Base
  attr_accessible :content, :filter, :weblink, :imagelink
  belongs_to :user
  has_many :eyes, foreign_key: "micropost_id", dependent: :destroy

  validates :content, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'


  def setVisibility(other_users)
    other_users.each do |u|
      eyes.create!(user_id: u.id)  
    end  
  end

  def getVisibility()
    returnUsers = []
    eyes.each do |u|
      user = User.find_by_id(u.user_id)
      if user == nil #if the user has been deleted in the meanwhile
        u.destroy #remove the eye
      else
        returnUsers.push(user)
      end 
    end
    returnUsers
  end

  def isVisible(user)
    visble = false
    if user.id == self.user.id
      visible = true
    else
      eyes.each do |eye|
        if eye.user_id ==  user.id 
          visible = true
        end 
      end  
    end
    visble  
  end

  def removeVisibility(user_id)
    eyes.find_by_user_id(user_id).destroy!
  end


end
