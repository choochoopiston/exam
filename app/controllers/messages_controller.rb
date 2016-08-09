class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
  
  after_action :sending_message_pusher, only: [:create]
  
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
    if @message.save
       @conversation = @message.conversation
       @receiver = @conversation.target_user(current_user)
       @notification = @message.notifications.build(recipient_id: @receiver.id, sender_id: current_user.id)
       @notification.save
       redirect_to conversation_messages_path(@conversation)
    end
  end
  
  private
    def message_params
      params.require(:message).permit(:body, :user_id)
    end
    
    def sending_message_pusher
      Notification.sending_message_pusher(@notification.recipient_id)
    end
end
