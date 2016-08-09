class Message < ActiveRecord::Base
    require 'strftimemodule'
    include Strftime
  
    belongs_to :conversation
    belongs_to :user
    
    has_many :notifications, dependent: :destroy
    accepts_nested_attributes_for :notifications
  
    validates_presence_of :content, :conversation_id, :user_id
    

end
