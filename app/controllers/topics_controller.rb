class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :sameuser, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  
  require 'strftimemodule'
  
  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all
    @topic = current_user.topics.build
    @comment = @topic.comments.build
    @comments = @topic.comments
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @comment = @topic.comments.build
    @comments = @topic.comments
  end

  # GET /topics/new
  def new
    @topic = current_user.topics.build
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = current_user.topics.build(topic_params)

    respond_to do |format|
      if @topic.save
        
        @topics = Topic.all
        @comments = @topic.comments
        @comment = @topic.comments.build
        format.html { redirect_to @topic, notice: 'トピックは作成されました' }
        format.json { render :show, status: :created, location: @topic }
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'トピックは更新されました' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'トピックは削除されました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:content, :user_id)
    end

    def sameuser
      @topic = Topic.find(params[:id])
      if current_user.id != @topic.user_id
        redirect_to root_path
      end
    end
end
