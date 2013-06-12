class Micropost < ActiveRecord::Base
  attr_accessible :content, :filter, :weblink, :imagelink
  belongs_to :user
  has_many :eyes, foreign_key: "micropost_id", dependent: :destroy

  validates :content, presence: true, length: { minimum: 1, maximum: 100 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'

  

  def setVisibility(other_users)
    other_users.each do |u|
        eyes.create!(user_id: u.id) unless isVisible(u)
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
    eyes.each do |eye|
      if eye.user_id ==  user.id 
        visible = true
      end 
    end      
    visble  
  end

  def removeVisibility(user_id)
    eyes.find_by_user_id(user_id).destroy!
  end

  def getColor()
    num = 0;
    eyes.each do |eye|
      num += eye.user_id
    end  

    mimosa = '#EFC050'      #yellow
    honeysuckle = '#D65076' #pink
    tigerlily = '#E15D44'   #orange red     
    turquoise = '#45B8AC'   #turkoise green
    sand = '#DFCFBE'        #brown
    cerulean = '#98B4D4'    #blue
    yellow = '#f7e8aa'      #light yellow
    green = '#c9e8dd'       #light green
    aqua = '#7FCDCD'        #blue/green
    fuchsia = '#C3447A'     #lila    
    colors = [yellow, green, honeysuckle, turquoise, mimosa, sand, tigerlily, aqua, fuchsia, cerulean]

    colors[num % colors.length]  
  end  
end
