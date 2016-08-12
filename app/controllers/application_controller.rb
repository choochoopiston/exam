class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  # before_actionでdeviseのストロングパラメーターにnameカラムを追加するメソッドを実行します。
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_follow, if: :user_signed_in?
  before_action :current_notifications

  def current_notifications
    @notifications = Notification.where.not(comment_id: nil).where(recipient_id: current_user).order(created_at: :desc).includes({comment: [:topic]})
    @notifications_count = Notification.where.not(comment_id: nil).where(recipient_id: current_user).order(created_at: :desc).unread.count
    @notifications_messages = Notification.where.not(message_id: nil).where(recipient_id: current_user).order(created_at: :desc).includes({message: [:conversation]})
    @notifications_messages_count = Notification.where.not(message_id: nil).where(recipient_id: current_user).order(created_at: :desc).unread.count
    @notifications_followers = Notification.where.not(relationship_id: nil).where(recipient_id: current_user).order(created_at: :desc)
    @notifications_followers_count = Notification.where.not(relationship_id: nil).where(recipient_id: current_user).order(created_at: :desc).unread.count
  end
  
  def current_follow
    @followed_users = current_user.followed_users
    @followers = current_user.followers
    @followed_eachothers = current_user.followed_users.order("created_at DESC")&current_user.followers.order("created_at DESC")
  end

  PERMISSIBLE_ATTRIBUTES = %i(name avatar avatar_cache remove_avatar)

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
    end
    
end
