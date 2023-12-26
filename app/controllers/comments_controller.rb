class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: [:create, :destroy]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    micropost = nil
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    # @comment = Comment.new(comment_params)
    if params[:comment_id]
      comment = Comment.find_by(id: params[:comment_id])
      @comment = comment.comments.build(comment_params) 
    else
      micropost = Micropost.find_by(id: params[:micropost_id]) 
      @comment = micropost.comments.build(comment_params)
    end 
    @comment.image.attach(params[:comment][:image])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to root_url, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    Comment.where(comment_id: @comment).each do |comment|
      comment.destroy!
    end
    @comment.destroy!
    flash[:success] = "Comment deleted"
    redirect_to request.referrer || root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find_by(id: params[:id]) 
      redirect_to comments_url if @comment.nil?
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :micropost_id, :comment_id, :image)
    end

end
