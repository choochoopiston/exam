class NotificationsController < ApplicationController

  def index
    @notifications = Notification.where.not(comment_id: nil).where(recipient_id: current_user.id).order(created_at: :desc).includes({comment: [:topic]})
    @notifications.update_all(read: true)
    @notifications_count = Notification.where.not(comment_id: nil).where(recipient_id: current_user).order(created_at: :desc).unread.count
  end
  
  def message
    @notifications_messages = Notification.where.not(message_id: nil).where(recipient_id: current_user.id).order(created_at: :desc).includes({comment: [:conversation]})
    @notifications_messages.update_all(read: true)
    @notifications_messages_count = Notification.where.not(message_id: nil).where(recipient_id: current_user).order(created_at: :desc).unread.count
  end
  
  def follower
    @notifications_followers = Notification.where.not(relationship_id: nil).where(recipient_id: current_user.id).order(created_at: :desc).includes({comment: [:conversation]})
    @notifications_followers.update_all(read: true)
    @notifications_followers_count = Notification.where.not(relationship_id: nil).where(recipient_id: current_user).order(created_at: :desc).unread.count
  end
  
end
