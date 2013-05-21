class Friend < ActiveRecord::Base
  attr_accessible :friend_id
  
  belongs_to :friend, class_name: "User"
  belongs_to :user, class_name: "User"
  validates :friend_id, presence: true
  validates :user_id, presence: true
end
