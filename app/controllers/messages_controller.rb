class MessagesController < ApplicationController
  
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
  
  before_action :sameuser, only: [:index]

  
  def index
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end
  
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
  
    @message = @conversation.messages.build
  end

  def new
    @message = @conversation.messages.build
  end

  def create
    @message = @conversation.messages.build(message_params)
    respond_to do |format|
      if @message.save
         @conversation = @message.conversation
         @receiver = @conversation.target_user(current_user)
         @notification = @message.notifications.build(recipient_id: @receiver.id, sender_id: current_user.id)
         @notification.save
         Notification.sending_message_pusher(@notification.recipient_id)
         format.html { redirect_to conversation_messages_path(@conversation), notice: 'コメントを投稿しました。' }
      else
         format.html { render :new }
      end
    end
  end
  
  private
    def message_params
      params.require(:message).permit(:body, :user_id)
    end
    
    def sending_message_pusher
      Notification.sending_message_pusher(@notification.recipient_id)
    end
    
    def sameuser
      @conversation = Conversation.find(params[:conversation_id])
      unless current_user.id == @conversation.sender_id ||　current_user.id == @conversation.recipient_id
        redirect_to root_path
      end
    end
    
end
