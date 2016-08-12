class Notification < ActiveRecord::Base
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::DateHelper
    
    require 'strftimemodule'
    include Strftime
    
    belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
    belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
    belongs_to :comment, foreign_key: :comment_id, class_name: 'Comment'
    belongs_to :message, foreign_key: :message_id, class_name: 'Message'
    belongs_to :relationship, foreign_key: :relationship_id, class_name: 'Relationship'
    
    scope :read, -> { where(read: true) }
    scope :unread, -> { where(read: nil) }
    scope :unread_count , -> (user_id) { where.not(comment_id: nil).where(recipient_id: user_id).unread.count }
    scope :unread_message_count , -> (user_id) { where.not(message_id: nil).where(recipient_id: user_id).unread.count }
    scope :unread_follower_count , -> (user_id) { where.not(relationship_id: nil).where(recipient_id: user_id).unread.count }
    
    def self.sending_pusher(channel_user_id)
        Pusher.trigger("midoku#{channel_user_id}", 'message', { 
            unread_count: Notification.unread_count(channel_user_id)
        })
    end
    
    def self.sending_message_pusher(channel_user_id)
        Pusher.trigger("newmessage#{channel_user_id}", 'message', { 
            unread_message_count: Notification.unread_message_count(channel_user_id)
        })
    end
    
    def self.sending_follower_pusher(channel_user_id)
        Pusher.trigger("newfollower#{channel_user_id}", 'message', { 
            unread_follower_count: Notification.unread_follower_count(channel_user_id)
        })
    end
end
