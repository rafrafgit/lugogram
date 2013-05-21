class Micropost < ActiveRecord::Base
  attr_accessible :content, :filter, :recipients
  belongs_to :user
  has_many :eyes, foreign_key: "micropost_id", dependent: :destroy

  
  before_save { |micropost| micropost.recipients = recipients.downcase }

  validates :content, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'


  def addEyes(other_user)
    eyes.create!(user_id: other_user.id)
  end

  def getUserEyes()
    returnUsers = []
    eyes.each do |u|
      returnUsers.push(User.find_by_id(u.user_id))
    end
    returnUsers
  end

  def removeEyes(user_id)
    eyes.find_by_user_id(user_id).destroy!
  end


end
