class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :sending_pusher, only: [:create]

  def index
    @topic = Topic.find(params[:topic_id])
    @comments = @topic.comments.order(updated_at: :asc)
      if(params[:hide_c] == "0" )
        @excess = true
        @comments =  @comments[-2..-1]
      else
        @excess = false
      end

    respond_to do |format|
        format.js { render :index }
    end

  end
  
  def edit
    @comment = Comment.find(params[:id])
    @topic = @comment.topic
    respond_to do |format|
        format.js
    end
  end

  def update
    @comment = Comment.find(params[:id])
    
    respond_to do |format|
      if @comment.update(comment_params)
         @topic = @comment.topic
        format.js
      else
      end
    end
  end
  
  # コメントを保存、投稿するためのアクションです。
  def create
    # ログインユーザーに紐付けてインスタンス生成するためbuildメソッドを使用します。
    @comment = current_user.comments.build(comment_params)
    @comment.topic_id = params[:topic_id]
    @topic = @comment.topic
    
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        
        @topic = @comment.topic
        @comments = @topic.comments
          if @comments.length > 2
             @excess = true
             @comments =  @comments[-2..-1]
          else
             @excess = false
          end
          
          if @topic.user_id != current_user.id
          @notification = @comment.notifications.build(recipient_id: @topic.user_id, sender_id: current_user.id)
          @notification.save
          end 
          
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        # JS形式でレスポンスを返します。
        format.js { render :index }
      else
        format.html { render :new }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to topic_path(@comment.topic_id), notice: 'コメントは削除されました。' }
      format.json { head :no_content }
      @topic = @comment.topic
      @comments = @topic.comments
        if @comments.length > 2
           @excess = true
           @comments =  @comments[-2..-1]
        else
           @excess = false
        end
      format.js { render :index, notice: 'コメントは削除されました。' }
    end
  end

  private
    # ストロングパラメーター
    def comment_params
      params.require(:comment).permit(:topic_id, :user_id, :content) 
    end
    
    def sending_pusher
      Notification.sending_pusher(@notification.recipient_id) if @topic.user_id != current_user.id
    end
    

end
