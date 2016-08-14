class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js
  
  after_action :sending_follower_pusher, only: [:create]

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    @relationship = Relationship.find_by(followed_id: @user, follower_id: current_user)
    @notification = @relationship.notifications.build(recipient_id: @user.id, sender_id: current_user.id)
    @notification.save
    @relationships = Relationship.where(follower_id: current_user).pluck(:followed_id)
    @reverse_relationships = Relationship.where(followed_id: current_user).pluck(:follower_id)
    @followed_eachothers = User.where(id: @relationships&@reverse_relationships)
 
    respond_with @user, @followed_eachothers
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    @relationships = Relationship.where(follower_id: current_user).pluck(:followed_id)
    @reverse_relationships = Relationship.where(followed_id: current_user).pluck(:follower_id)
    @followed_eachothers = User.where(id: @relationships&@reverse_relationships)
    respond_with @user, @followed_eachothers
  end

  private

    def sending_follower_pusher
      Notification.sending_follower_pusher(@notification.recipient_id)
    end
  
end
