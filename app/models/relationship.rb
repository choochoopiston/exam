class Relationship < ActiveRecord::Base
  
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
    
    has_many :notifications, foreign_key: "follower_id", dependent: :destroy
    accepts_nested_attributes_for :notifications


end
