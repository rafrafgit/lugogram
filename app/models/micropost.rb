class Micropost < ActiveRecord::Base
  attr_accessible :content, :filter, :recipients
  belongs_to :user

  
  before_save { |micropost| micropost.recipients = recipients.downcase }

  validates :content, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :recipients, presence:   true, format: { with: VALID_EMAIL_REGEX }
  
  default_scope order: 'microposts.created_at DESC'
end
